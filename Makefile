.PHONY: run test

run:
	go build -o notely && ./notely

fmt:
	@files="$$(go fmt ./...)"; \
	if [ -n "$$files" ]; then \
	  echo "Formatted:" $$files; \
	fi

test: fmt
	go test ./...
