# Plumber REST API as a DataStorage provider for shiny.telemetry

The R code is a courtesy of Appsilon, cloned from [shiny.telemetry](https://github.com/Appsilon/shiny.telemetry/tree/85add128cfd40d43d4a40694ac891d99625b9876/plumber_rest_api)
repository at `85add128cfd40d43d4a40694ac891d99625b9876` commit.

In the scope of this project a few changes have been made to the code:

- Added Dockerfile
- Re-created renv.lock and renv/activate.R files
- Explicitly set plumber port to `0.0.0.0` to work with Docker
- Change the path to stored logfile to allow for a Docker Volume
