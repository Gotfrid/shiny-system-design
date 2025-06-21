mock_redis_client <- list(GET = function(...) NULL, SET = function(...) NULL)
redis_client <- {
  config <- list(host = redis_host, port = redis_port)
  if (redis_available(config)) {
    hiredis(config = list(host = redis_host, port = redis_port))
  } else {
    warning("Cache is not available.", call. = FALSE)
    mock_redis_client
  }
}
