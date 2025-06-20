FROM rocker/r-ver:4.5.0

RUN install2.r plumber --error --skipinstalled

WORKDIR /app
COPY . .

CMD ["Rscript", "app.R"]
