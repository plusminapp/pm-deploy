include .env
export

include lcl/lcl.env
include dev/dev.env
include stg/stg.env
export

export LCL_PLATFORM=linux/$(shell uname -m | sed 's/x86_64/amd64/' | sed 's/aarch64/arm64/')

# local lcl
lcl-pm-frontend-build: export VERSION=${PM_LCL_VERSION}
lcl-pm-frontend-build: export PLATFORM=${LCL_PLATFORM}
lcl-pm-frontend-build: export PORT=3035
lcl-pm-frontend-build: export STAGE=lcl
lcl-pm-frontend-build:
	echo folder: ${PROJECT_FOLDER} platform: ${LCL_PLATFORM} version: ${VERSION}
	cp lcl/lcl.env ${PROJECT_FOLDER}/pm-frontend/lcl.env
	${PROJECT_FOLDER}/pm-frontend/build-docker.sh

lcl-pm-backend-build: export VERSION=${PM_LCL_VERSION}
lcl-pm-backend-build: export PLATFORM=${LCL_PLATFORM}
lcl-pm-backend-build:
	${PROJECT_FOLDER}/pm-backend/build-docker.sh

lcl-pm-openapi-build: export VERSION=${PM_LCL_VERSION}
lcl-pm-openapi-build: export PLATFORM=${LCL_PLATFORM}
lcl-pm-openapi-build:
	${PROJECT_FOLDER}/pm-backend/build-openapi.sh

lcl-pm-database-build: export VERSION=${PM_LCL_VERSION}
lcl-pm-database-build: export PLATFORM=${LCL_PLATFORM}
lcl-pm-database-build:
	${PROJECT_FOLDER}/pm-database/build-docker.sh

lcl-build-all: lcl-pm-frontend-build lcl-pm-backend-build lcl-pm-database-build

lcl-remove-all-incl-database:
	docker compose -f lcl/docker-compose.lcl.yml down -v

lcl-deploy-all:
	docker compose -f lcl/docker-compose.lcl.yml down
	docker network inspect npm_default >/dev/null 2>&1 || docker network create -d bridge npm_default
	docker compose -f lcl/docker-compose.lcl.yml up -d
	@echo "Waiting for pm-backend-lcl to accept connections..."
	@for i in $$(seq 1 30); do \
		printf "\rChecking pm-backend-lcl... attempt $$i/30"; \
		if docker exec pm-backend-lcl sh -c 'curl localhost:3045/api/v1/v3/api-docs 2>/dev/null' >/dev/null 2>&1; then \
			printf "\npm-backend-lcl is ready! (took $$(($$i)) seconds)\n"; \
			break; \
		elif [ $$i -eq 30 ]; then \
			printf "\nWarning: pm-backend-lcl not responding after 30 seconds\n"; \
		else \
			sleep 1; \
		fi; \
	done
	$(MAKE) lcl-pm-openapi-build

lcl-frontend: lcl-pm-frontend-build lcl-deploy-all
lcl-backend: lcl-pm-backend-build lcl-deploy-all
lcl-all: lcl-build-all lcl-deploy-all

# development dev
dev-pm-frontend-build: export VERSION=${PM_DEV_VERSION}
dev-pm-frontend-build: export PLATFORM=linux/amd64
dev-pm-frontend-build: export PORT=3035
dev-pm-frontend-build: export STAGE=dev
dev-pm-frontend-build:
	cp dev/dev.env ${PROJECT_FOLDER}/pm-frontend/dev.env
	${PROJECT_FOLDER}/pm-frontend/build-docker.sh

dev-pm-backend-build: export VERSION=${PM_DEV_VERSION}
dev-pm-backend-build: export PLATFORM=linux/amd64
dev-pm-backend-build:
	${PROJECT_FOLDER}/pm-backend/build-docker.sh

dev-pm-database-build: export VERSION=${PM_DEV_VERSION}
dev-pm-database-build: export PLATFORM=linux/amd64
dev-pm-database-build:
	${PROJECT_FOLDER}/pm-database/build-docker.sh

dev-build-all: dev-pm-frontend-build dev-pm-backend-build dev-pm-database-build

dev-copy-database:
	./docker-cp.sh database DEV
dev-copy-frontend:
	./docker-cp.sh frontend DEV
dev-copy-backend:
	./docker-cp.sh backend DEV
dev-copy-all: dev-copy-database dev-copy-frontend dev-copy-backend

dev-deploy-frontend:
	cat .env dev/dev.env | ssh box 'cat > ~/pm/.env'
	ssh box 'sudo su -c "cd ~/pm && ~/pm/pm_deploy.sh dev pm-frontend-dev" - ruud'
dev-deploy-backend:
	cat .env dev/dev.env | ssh box 'cat > ~/pm/.env'
	ssh box 'sudo su -c "cd ~/pm && ~/pm/pm_deploy.sh dev pm-backend-dev" - ruud'
dev-deploy-all:
	cat .env dev/dev.env | ssh box 'cat > ~/pm/.env'
	ssh box 'sudo su -c "cd ~/pm && ~/pm/pm_deploy.sh dev" - ruud'

dev-frontend: dev-pm-frontend-build dev-copy-frontend dev-deploy-frontend
dev-backend: dev-pm-backend-build dev-copy-backend dev-deploy-backend
dev-all: dev-build-all dev-copy-all dev-deploy-all

# staging stg
stg-pm-frontend-build: export VERSION=${PM_STG_VERSION}
stg-pm-frontend-build: export PLATFORM=linux/amd64
stg-pm-frontend-build: export PORT=3030
stg-pm-frontend-build: export STAGE=stg
stg-pm-frontend-build:
	cp stg/stg.env ${PROJECT_FOLDER}/pm-frontend/stg.env
	${PROJECT_FOLDER}/pm-frontend/build-docker.sh

stg-pm-backend-build: export VERSION=${PM_STG_VERSION}
stg-pm-backend-build: export PLATFORM=linux/amd64
stg-pm-backend-build:
	${PROJECT_FOLDER}/pm-backend/build-docker.sh

stg-pm-database-build: export VERSION=${PM_STG_VERSION}
stg-pm-database-build: export PLATFORM=linux/amd64
stg-pm-database-build:
	${PROJECT_FOLDER}/pm-database/build-docker.sh

stg-build-all: stg-pm-frontend-build stg-pm-backend-build stg-pm-database-build

stg-copy-database:
	./docker-cp.sh database STG
stg-copy-frontend:
	./docker-cp.sh frontend STG
stg-copy-backend:
	./docker-cp.sh backend STG
stg-copy-all: stg-copy-database stg-copy-frontend stg-copy-backend

stg-deploy-frontend:
	cat .env stg/stg.env | ssh box 'cat > ~/pm/.env'
	ssh box 'sudo su -c "cd ~/pm && ~/pm/pm_deploy.sh stg pm-frontend-stg" - ruud'
stg-deploy-backend:
	cat .env stg/stg.env | ssh box 'cat > ~/pm/.env'
	ssh box 'sudo su -c "cd ~/pm && ~/pm/pm_deploy.sh stg pm-backend-stg" - ruud'
stg-deploy-all:
	cat .env stg/stg.env | ssh box 'cat > ~/pm/.env'
	ssh box 'sudo su -c "cd ~/pm && ~/pm/pm_deploy.sh stg" - ruud'

stg-frontend: stg-pm-frontend-build stg-copy-frontend stg-deploy-frontend
stg-backend: stg-pm-backend-build stg-copy-backend stg-deploy-backend
stg-all: stg-build-all stg-copy-all stg-deploy-all

# remote
.PHONY: dev-remote stg-remote
dev-remote:
	scp dev/* box:~/pm/
stg-remote:
	scp stg/* box:~/pm/
