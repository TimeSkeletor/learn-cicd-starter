APP = notely

STYLE_CHECK = staticcheck
STYLE_CHECK_REPO = honnef.co/go/tools/cmd/staticcheck@latest

SECURITY_CHECK = gosec
SECURITY_CHECK_REPO = github.com/securego/gosec/v2/cmd/gosec@latest

PORT = 8080

OWNER = TimeSkeletor



.PHONY: run test fmt style_check security_check build docker_build docker_run

run:
	go build -o notely && ./notely

build:
	./scripts/buildprod.sh


docker_build:
	docker build -t ${OWNER}/${APP}:latest .

docker_run:
	docker run -e PORT=${PORT} -p 8080:${PORT} ${OWNER}/${APP}:latest

fmt:
	@files="$$(go fmt ./...)"; \
	if [ -n "$$files" ]; then \
	  echo "Formatted:" $$files; \
	fi

install_style_check:
	@echo "Checking for ${STYLE_CHECK} presence..."
	if command -v ${STYLE_CHECK} >/dev/null 2>&1; then \
		echo "${STYLE_CHECK} already installed"; \
	else \
		go install ${STYLE_CHECK_REPO}; \
	fi

style_check: install_style_check
	@echo "Checking style with ${STYLE_CHECK}..."
	${STYLE_CHECK} ./...

install_security_check:
	@echo "Checking for ${SECURITY_CHECK} presence..."
	if command -v ${SECURITY_CHECK} >/dev/null 2>&1; then \
		echo "${SECURITY_CHECK} already installed"; \
	else \
		go install ${SECURITY_CHECK_REPO}; \
	fi

security_check: install_security_check
	@echo "Checking security with ${SECURITY_CHECK}..."
	${SECURITY_CHECK} ./...

testing_step:
	@echo "Testing code..."
	go test -cover ./...

test: fmt style_check testing_step security_check

