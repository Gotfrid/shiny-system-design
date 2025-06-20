FROM julia:1.11-bookworm

RUN julia -e 'import Pkg; Pkg.add("HTTP"); Pkg.add("Oxygen")'

WORKDIR /app
COPY app.jl .

CMD ["julia", "app.jl"]
