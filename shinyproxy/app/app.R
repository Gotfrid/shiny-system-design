library(bslib)
library(httr2)
library(languageserver)
library(mirai)
library(redux)
library(RPostgreSQL)
library(shiny.telemetry)
library(shiny)

api_frameworks <- c(
  "fastapi",
  "oxygen",
  "plumber",
  "gin",
  "express",
  "spring"
)

pg_usr <- Sys.getenv("PG_USR", "postgres")
pg_pwd <- Sys.getenv("PG_PWD", "postgres")
pg_host <- Sys.getenv("PG_HOST", "database")
pg_port <- as.numeric(Sys.getenv("PG_PORT", "5432"))
pg_db <- Sys.getenv("PG_DB", "postgres")

api_dispatcher_url <- Sys.getenv(
  "API_DISPATCHER_URL",
  "http://api_dispatcher:8000"
)
api_dispatcher_msg_path <- Sys.getenv(
  "API_DISPATCHER_MSG_PATH",
  "hello"
)

mock_telemetry_client <- list(start_session = function(...) NULL)
telemetry_client <- tryCatch(
  expr = {
    t <- Telemetry$new(
      app_name = "shiny_system_design__main_app",
      data_storage = DataStoragePostgreSQL$new(
        username = pg_usr,
        password = pg_pwd,
        hostname = pg_host,
        port = pg_port,
        dbname = pg_db,
        driver = "RPostgreSQL"
      )
    )
    t$log_custom_event("Startup test")
    t
  },
  error = function(e) {
    if (grepl("RPosgreSQL error: could not connect", as.character(e))) {
      warning("Telemetry cannot be collected:\n", e, call. = FALSE)
      return(mock_telemetry_client)
    }
    stop(e)
  }
)

ui <- function(request) {
  page_sidebar(
    sidebar = sidebar(
      selectizeInput("api_target", "API Target", api_frameworks),
      input_task_button("make_request", "Make Request")
    ),
    use_telemetry(),
    verbatimTextOutput("log"),
  )
}

server <- function(input, output, session) {
  telemetry_client$start_session(track_values = TRUE)

  responses_log <- reactiveVal(paste0(
    "This is the beginning of the log.\n",
    "Start making requests to see the responses.\n"
  ))

  api_task <- ExtendedTask$new(function(api_target, url, path) {
    mirai(
      {
        req <- httr2::request(url) |>
          httr2::req_url_path(path) |>
          httr2::req_method("GET") |>
          httr2::req_headers(ApiTarget = api_target)
        res <- try(httr2::req_perform(req))
        if (inherits(res, "try-error")) {
          return(
            paste(Sys.time(), api_target, "FAIL:", attr(res, "condition"))
          )
        }
        data <- httr2::resp_body_json(res)
        paste(Sys.time(), api_target, "OK:", as.character(data))
      },
      api_target = api_target,
      url = api_dispatcher_url,
      path = api_dispatcher_msg_path
    )
  }) |>
    bind_task_button("make_request")

  observeEvent(input$make_request, {
    new_line <- paste(Sys.time(), input$api_target, "BEGIN", "\n")
    paste0(responses_log(), new_line) |> responses_log()
    api_task$invoke(api_target = input$api_target)
  })

  observeEvent(api_task$result(), {
    new_line <- paste0(api_task$result(), "\n")
    paste0(responses_log(), new_line) |> responses_log()
  })

  output$log <- renderText(responses_log())
}

mirai::daemons(1)
onStop(function() mirai::daemons(0))
shinyApp(ui, server)
