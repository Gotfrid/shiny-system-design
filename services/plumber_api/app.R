library(plumber)

root <- pr("plumber.R")
pr_run(root, port = 8000, host = "0.0.0.0")
