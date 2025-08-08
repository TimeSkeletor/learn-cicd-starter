.PHONY: run test fmt staticcheck

run:
	go build -o notely && ./notely

fmt:
	@files="$$(go fmt ./...)"; \
	if [ -n "$$files" ]; then \
	  echo "Formatted:" $$files; \
	fi

install_staticcheck:
	if dpkg -s staticcheck >/dev/null 2>&1; then \
		echo ""; \
	else \
		go install honnef.co/go/tools/cmd/staticcheck@latest \
	fi

staticcheck:
	staticcheck ./...

test: fmt staticcheck
	go test ./...
