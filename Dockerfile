# syntax=docker/dockerfile:1

## Build
FROM golang:1.20-buster AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download
COPY ./cmd/ops-test-app/main.go ./cmd/ops-test-app/main.go
RUN GOOS=linux GOARCH=amd64 go build -o ops-test-app cmd/ops-test-app/main.go

## Deploy
FROM gcr.io/distroless/base-debian10

WORKDIR /

COPY --from=build /app/ops-test-app ops-test-app

EXPOSE 8080

USER nonroot:nonroot

ENTRYPOINT ["/ops-test-app"]