# Alpine GoLang Docker Image
FROM golang:1.20.2-alpine3.17

# Set the working directory inside the container
WORKDIR /app

# Copy the Go modules and the source code to the container
COPY app/go.mod .
COPY app/main.go .

# Build the Go application inside the container
RUN go build -o main .

# Expose port 8080 for the container to listen on
EXPOSE 8080

# Define the command to run when the container starts
CMD ["./main"]