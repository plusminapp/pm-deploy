include .env
export

include lcl/lcl.env
include dev/dev.env
include stg/stg.env
export

# local lcl
lcl-pm-frontend-build: export VERSION=${PM_LCL_VERSION}
lcl-pm-frontend-build: export PLATFORM=linux/arm64
lcl-pm-frontend-build: export PORT=3035
lcl-pm-frontend-build: export STAGE=lcl
lcl-pm-frontend-build:
	echo ${PROJECT_FOLDER}
	cp lcl/lcl.env ${PROJECT_FOLDER}/pm-frontend/lcl.env
	${PROJECT_FOLDER}/pm-frontend/docker-build.sh

lcl-pm-backend-build: export VERSION=${PM_LCL_VERSION}
lcl-pm-backend-build: export PLATFORM=linux/arm64
lcl-pm-backend-build:
	${PROJECT_FOLDER}/pm-backend/docker-build.sh

lcl-pm-database-build: export VERSION=${PM_LCL_VERSION}
lcl-pm-database-build: export PLATFORM=linux/arm64
lcl-pm-database-build:
	${PROJECT_FOLDER}/pm-database/docker-build.sh

lcl-build-all: lcl-pm-frontend-build lcl-pm-backend-build lcl-pm-database-build

lcl-deploy-frontend:
lcl-deploy-all:
	docker network inspect npm_default >/dev/null 2>&1 || docker network create -d bridge npm_default
	docker compose -f lcl/docker-compose.lcl.yml up -d

lcl-frontend: lcl-pm-frontend-build lcl-deploy-frontend
lcl-backend: lcl-pm-backend-build lcl-deploy-backend
lcl-all: lcl-build-all lcl-deploy-all

# development dev
dev-pm-frontend-build: export VERSION=${PM_DEV_VERSION}
dev-pm-frontend-build: export PLATFORM=linux/amd64
dev-pm-frontend-build: export PORT=3035
dev-pm-frontend-build: export STAGE=dev
dev-pm-frontend-build:
	cp dev/dev.env ${PROJECT_FOLDER}/pm-frontend/dev.env
	${PROJECT_FOLDER}/pm-frontend/docker-build.sh

dev-pm-backend-build: export VERSION=${PM_DEV_VERSION}
dev-pm-backend-build: export PLATFORM=linux/amd64
dev-pm-backend-build:
	${PROJECT_FOLDER}/pm-backend/docker-build.sh

dev-pm-database-build: export VERSION=${PM_DEV_VERSION}
dev-pm-database-build: export PLATFORM=linux/amd64
dev-pm-database-build:
	${PROJECT_FOLDER}/pm-database/docker-build.sh

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
	${PROJECT_FOLDER}/pm-frontend/docker-build.sh

stg-pm-backend-build: export VERSION=${PM_STG_VERSION}
stg-pm-backend-build: export PLATFORM=linux/amd64
stg-pm-backend-build:
	${PROJECT_FOLDER}/pm-backend/docker-build.sh

stg-pm-database-build: export VERSION=${PM_STG_VERSION}
stg-pm-database-build: export PLATFORM=linux/amd64
stg-pm-database-build:
	${PROJECT_FOLDER}/pm-database/docker-build.sh

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
