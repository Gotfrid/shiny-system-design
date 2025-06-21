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
      warning("Telemetry is not available.", call. = FALSE)
      return(mock_telemetry_client)
    }
    stop(e)
  }
)
