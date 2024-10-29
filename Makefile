.PHONY: build
build:
	docker build -t jeppeallerslev/elixir-exporter:latest .

.PHONY: push
push: build
	docker push jeppeallerslev/elixir-exporter:latest

.PHONY: compose
compose: 
	COMPOSE_FILE=./compose/docker-compose.yml docker compose up -d
