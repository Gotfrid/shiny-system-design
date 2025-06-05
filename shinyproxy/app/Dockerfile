ARG R_VERSION=4.4.2

FROM rocker/r-ver:${R_VERSION}

WORKDIR /app

# Install system packages
RUN apt update && apt install -y unixodbc libcurl4-openssl-dev libicu-dev libsodium-dev libssl-dev cmake xz-utils

# Install R packages
COPY ./renv/activate.R /app/renv/activate.R
COPY .Rprofile renv.lock /app/
RUN install2.r renv --error --skipinstalled
RUN R -q -e "renv::restore(clean=TRUE)"

COPY . .
