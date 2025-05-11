ARG R_VERSION=4.4.2

FROM rocker/r-ver:${R_VERSION}

WORKDIR /app

# Install R packages
COPY ./renv/activate.R /app/renv/activate.R
COPY .Rprofile renv.lock /app/
ENV RENV_CONFIG_PAK_ENABLED=TRUE
RUN install2.r renv --error --skipinstalled
RUN R -q -e "renv::restore(clean=TRUE)"

COPY . .

CMD ["Rscript", "plumber.R"]
