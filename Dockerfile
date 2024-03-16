# Build stage
FROM golang:1.22-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy the Go module files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the entire application
COPY . .

# Build the application
RUN go build -o main ./cmd/main.go

# Final stage
FROM alpine:latest

# Set the working directory
WORKDIR /app

# Copy the binary from the build stage
COPY --from=builder /app/main .

# Copy the configuration files (if any)
COPY --from=builder /app/config /app/config

# Expose the port your application listens on
EXPOSE 8080

# Set the entrypoint to run the binary
ENTRYPOINT ["./main"]