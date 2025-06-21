#' Trigger reactive value with a random value
#' @param r {shiny::reactiveVal}
trigger_reactive <- function(r) {
  nonce <- stats::rnorm(1)
  r(nonce)
}
