mock_redis_client <- list(GET = function(...) NULL, SET = function(...) NULL)

get_redis_client <- function() {
  config <- list(host = redis_host, port = redis_port)
  if (redux::redis_available(config)) {
    redux::hiredis(config = list(host = redis_host, port = redis_port))
  } else {
    warning("Cache is not available.", call. = FALSE)
    mock_redis_client
  }
}
