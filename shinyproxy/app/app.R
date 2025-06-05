# Source code courtesy of Posit team
# at https://shiny.posit.co/

library(bslib)
library(dplyr)
library(ggExtra)
library(ggplot2)
library(mirai)
library(shiny.telemetry)
library(shiny)

penguins_csv <- "./datasets/penguins.csv"

df <- readr::read_csv(penguins_csv)
# Find subset of columns that are suitable for scatter plot
df_num <- df |> select(where(is.numeric), -Year)

telemetry <- tryCatch(
  expr = {
    t <- Telemetry$new(
      app_name = "penguins_explorer",
      data_storage = DataStoragePlumber$new(
        hostname = "telemetry_api",
        port = 8087,
        protocol = "http",
        path = NULL,
        secret = NULL,
        authorization = NULL
      )
    )
    t$log_custom_event("Startup test")
    t
  },
  error = function(e) {
    if (!inherits(e, "httr2_error")) {
      stop(e)
    }
    warning(e)
    list(start_session = function(...) NULL)
  }
)


ui <- function(request) {
  page_sidebar(
    sidebar = sidebar(
      selectInput("xvar", "X variable", names(df_num), selected = "Bill Length (mm)"),
      selectInput("yvar", "Y variable", names(df_num), selected = "Bill Depth (mm)"),
      checkboxGroupInput(
        "species", "Filter by species",
        choices = unique(df$Species), 
        selected = unique(df$Species)
      ),
      hr(), # Add a horizontal rule
      checkboxInput("by_species", "Show species", TRUE),
      checkboxInput("show_margins", "Show marginal plots", TRUE),
      checkboxInput("smooth", "Add smoother"),
      input_task_button("sklearn_predict", "SKLearn Classification")
    ),
    use_telemetry(),
    plotOutput("scatter")
  )
}

server <- function(input, output, session) {
  telemetry$start_session(track_values = TRUE)

  sklearn_task <- ExtendedTask$new(function(x, y) {
    mirai({
      req <- httr2::request("http://class_service:8000/predict") |>
        httr2::req_method("POST") |>
        httr2::req_body_json(list(x = x, y = y))
      res <- httr2::req_perform(req)
      res |>
        httr2::resp_body_json()
    }, x = x, y = y)
  }) |>
    bind_task_button("sklearn_predict")

  subsetted <- reactive({
    req(input$species)
    df |> filter(Species %in% input$species)
  })

  observeEvent(input$sklearn_predict, {
    req(subsetted())
    data <- subsetted()
    sklearn_task$invoke(x = data[, c(3:5)], y = data[, 1])
  })

  observeEvent(sklearn_task$result(), {
    print(sklearn_task$result())
  })

  output$scatter <- renderPlot({
    p <- ggplot(subsetted(), aes(x = get(input$xvar), y = get(input$yvar))) + list(
      theme(legend.position = "bottom"),
      if (input$by_species) aes(color = Species),
      geom_point(),
      if (input$smooth) geom_smooth()
    )

    if (input$show_margins) {
      margin_type <- if (input$by_species) "density" else "histogram"
      p <- ggExtra::ggMarginal(p, type = margin_type, margins = "both",
        size = 8, groupColour = input$by_species, groupFill = input$by_species)
    }

    p
  }, res = 100)
}

mirai::daemons(1)

# automatically shutdown daemons when app exits
onStop(function() mirai::daemons(0))

shinyApp(ui, server)
