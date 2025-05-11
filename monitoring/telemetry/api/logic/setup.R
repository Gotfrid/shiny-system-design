box::use(
  config,
  shiny.telemetry[
    DataStorageSQLite, DataStorageLogFile, build_id_from_secret,
  ],
  rlang[abort],
  digest[digest],
  checkmate[test_string],
  purrr[pluck, set_names],
  stringr[str_trim, str_sub],
  logger[log_warn, log_debug, log_info],
  dplyr[`%>%`],
)

#
setup_storage <- function() {
  DataStorageLogFile$new(
    log_file_path = normalizePath(file.path(
      getOption('box.path'),
      "logs",
      "user_stats.txt"
    ))
  )
}

#
setup_secrets <- function(tokens_raw) {
  if (!test_string(tokens_raw, null.ok = TRUE)) {
   rlang::abort("SECRET_TOKENS environmental variable must be a string")
  }

  if (is.null(tokens_raw) || str_trim(tokens_raw) == "") {

    if(!config$get("allow_empty_tokens")) {
      rlang::abort("SECRET_TOKENS environmental variable must be defined.")
    }

    return(NULL)
  }

  str_trim(tokens_raw) %>%
    strsplit(" +") %>%
    pluck(1) %>%
    set_names(~sapply(., shiny.telemetry::build_id_from_secret))
}

#' @export
session_secrets <- setup_secrets(config$get("tokens"))

#' @export
data_storage <- setup_storage()
