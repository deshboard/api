BUILD_SERVICES=db gateway_init

# Setup environment
setup: build
	mkdir -p var/
	make migrate
	make gateway

# Build the service and test containers
build:
ifeq ($(FORCE), true)
	@docker-compose --file docker-compose.yml --file docker-compose.util.yml build --force-rm $(BUILD_SERVICES)
else
	@docker-compose --file docker-compose.yml --file docker-compose.util.yml build $(BUILD_SERVICES)
endif

# Start the environment
start:
	@docker-compose up -d

# Stop the environment
stop:
ifeq ($(FORCE), true)
	@docker-compose kill
else
	@docker-compose stop
endif

# Clean environment
clean: stop
	@rm -rf var/
	@docker-compose rm --force

# Run database migrations
migrate:
	@docker-compose up -d db
	@docker-compose --file docker-compose.yml --file docker-compose.util.yml run --rm db_check
	@docker-compose --file docker-compose.yml --file docker-compose.util.yml run --rm service.model.user.migration update

# Initialize gateway
gateway:
	@@docker-compose up -d gateway_db
	@docker-compose --file docker-compose.yml --file docker-compose.util.yml run --rm gateway_db_check
	@@docker-compose up -d gateway
	@docker-compose --file docker-compose.yml --file docker-compose.util.yml run --rm gateway_check
	@docker-compose --file docker-compose.yml --file docker-compose.util.yml run --rm gateway_init
	@docker-compose restart gateway

.PHONY: setup build start stop clean update migrate gateway
