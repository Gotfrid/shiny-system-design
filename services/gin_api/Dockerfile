FROM golang:1.22

WORKDIR /app

COPY . .

RUN go build -o ./main ./main.go

CMD ["./main"]
