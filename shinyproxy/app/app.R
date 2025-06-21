library(bslib)
library(httr2)
library(languageserver)
library(redux)
library(RPostgreSQL)
library(shiny.telemetry)
library(shiny)

redis_client <- get_redis_client()
telemetry_client <- get_telemetry_client()

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

  api_request_trigger <- reactiveVal()
  responses_log <- reactiveVal(paste0(
    "This is the beginning of the log.\n",
    "Start making requests to see the responses.\n"
  ))

  observeEvent(input$make_request, {
    new_line <- paste(get_datetime(), input$api_target, "BEGIN", "\n")
    paste0(responses_log(), new_line) |> responses_log()
    trigger_reactive(api_request_trigger)
    update_task_button("make_request", state = "busy")
  })

  observeEvent(api_request_trigger(), {
    new_log_line <- make_request(input$api_target, redis_client)
    paste0(responses_log(), new_log_line) |> responses_log()
    update_task_button("make_request", state = "ready")
  })

  output$log <- renderText(responses_log())
}

shinyApp(ui, server)
