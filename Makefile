.PHONY: setup lint test build scan compose-config reset

setup:
	npm install

lint:
	npm run lint

test:
	npm run test

build:
	npm run build

scan:
	npm run secret:scan

compose-config:
	docker compose config

reset:
	docker compose down --volumes --remove-orphans
	docker compose up --build
