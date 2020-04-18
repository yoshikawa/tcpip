GOCMD=go
GORUN=$(GOCMD) run
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get
GODOC=$(GOCMD) doc
COMPOSE=docker-compose
EXEC=$(COMPOSE) exec
BUILD=$(COMPOSE) build
UP=$(COMPOSE) up -d
LOGS=$(COMPOSE) logs
STOP=$(COMPOSE) stop
RM=$(COMPOSE) rm
DOWN=$(COMPOSE) down
ASD=$(EXEC) asd
DB=$(EXEC) db
DBNAME:=tcpip
TESTDBNAME:=test_tcpip
MYSQL:=mysql --defaults-extra-file=/home/access.cnf

all: docker/up ## docker up & migrate

migrate/init: ## migrate init
	$(DB) /home/wait.sh
	$(DB) $(MYSQL) -e "create database if not exists \`$(DBNAME)\`"

migrate/test-init: ## migrate test database init
	$(DB) /home/wait.sh
	$(DB) $(MYSQL) -e "create database if not exists \`$(TESTDBNAME)\`"

migrate/up: ## migrate up
	$(API) goose up

migrate/down: ## migrate down
	$(API) goose down

docker/build: ## docker build
	$(BUILD)

docker/up: ## docker up
	$(UP)

docker/logs: ## docker logs
	$(LOGS)

docker/stop: ## docker stop
	$(STOP)

docker/clean: ## docker clean
	$(RM)

docker/down: ## docker down
	$(DOWN)

asd/bash: ## asd container bash
	$(ASD) bash

db/bash: ## db(MySQL) container bash
	$(DB) bash

run: ## go run main.go
	$(ASD) $(GORUN) main.go

test: ## go test
	$(ASD) $(GOTEST) -v ./...

doc: ## godoc http:6060
	$(GODOC) -http=:6060

help: ## Display this help screen
	@grep -E '^[a-zA-Z/_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'