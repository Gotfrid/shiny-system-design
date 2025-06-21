#' Make request to one of the defined services
#' @param api_target {character(1)}
make_request <- function(api_target) {
  stopifnot(api_target %in% api_frameworks)

  new_log_line <- ""

  req <- httr2::request(api_dispatcher_url) |>
    httr2::req_url_path(api_dispatcher_msg_path) |>
    httr2::req_method("GET") |>
    httr2::req_headers(ApiTarget = api_target)

  res <- try(httr2::req_perform(req))

  if (inherits(res, "try-error")) {
    new_log_line <- paste(
      Sys.time(), api_target, "FAIL:", attr(res, "condition")$message, "\n"
    )
  } else {
    data <- httr2::resp_body_json(res)
    new_log_line <- paste(
      Sys.time(), api_target, "OK:", as.character(data), "\n"
    )
  }

  new_log_line
}
