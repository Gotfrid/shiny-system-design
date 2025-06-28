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
pg_host <- Sys.getenv("PG_HOST", "monitoring_db")
pg_port <- as.numeric(Sys.getenv("PG_PORT", "5432"))
pg_db <- Sys.getenv("PG_DB", "postgres")

redis_host <- Sys.getenv("REDIS_HOST", "redis")
redis_port <- as.integer(Sys.getenv("REDIS_PORT", "6379"))

api_dispatcher_url <- Sys.getenv(
  "API_DISPATCHER_URL",
  "http://api_dispatcher:8000"
)
api_dispatcher_msg_path <- Sys.getenv(
  "API_DISPATCHER_MSG_PATH",
  "hello"
)
