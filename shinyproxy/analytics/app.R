library(DT)
library(plotly)
library(semantic.dashboard)
library(shiny.telemetry)
library(shinyjs)
library(timevis)

data_storage <- shiny.telemetry::DataStoragePlumber$new(
  hostname = "telemetry_api",
  port = 8087,
  protocol = "http",
  path = NULL,
  secret = NULL,
  authorization = NULL
)

analytics_app(data_storage = data_storage)
