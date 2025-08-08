.PHONY: run test

run:
	go build -o notely && ./notely

test:
	go test ./...