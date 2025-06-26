#' Make request to one of the defined services
#' @param api_target {character(1)}
#' @param force_fail {logical(1)}
#' @param cache_client {hiredis or list-like with GET and SET}
make_request <- function(api_target, force_fail, cache_client) {
  stopifnot(api_target %in% api_frameworks)

  new_log_entry <- c(get_datetime(), api_target)

  req <- httr2::request(api_dispatcher_url) |>
    httr2::req_url_path(api_dispatcher_msg_path) |>
    httr2::req_method("GET") |>
    httr2::req_headers(ApiTarget = api_target)

  if (force_fail) {
    req <- httr2::req_method(req, "POST")
  }

  cache_key <- paste0(as.character(req), collapse = "---")
  cached_value <- cache_client$GET(cache_key)

  if (is.null(cached_value)) {
    new_log_entry <- c(new_log_entry, "CACHE_MISS")
  } else {
    new_log_entry <- c(
      new_log_entry, "CACHE_HIT", as.character(cached_value), "\n"
    )
    return(paste(new_log_entry, collapse = " "))
  }

  response <- try(httr2::req_perform(req))
  if (inherits(response, "try-error")) {
    result <- paste("FAIL:", attr(response, "condition")$message)
  } else {
    data <- httr2::resp_body_json(response)
    result <- paste("OK:", as.character(data))
    cache_client$SET(cache_key, result)
  }

  new_log_entry <- c(new_log_entry, result, "\n")
  paste(new_log_entry, collapse = " ")
}
