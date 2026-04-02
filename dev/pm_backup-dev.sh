#!/bin/bash

# dev: dev

FILENAME=~/io.vliet/pm/backup-dev/pm-backup-dev-`date +%Y%m%d"-"%H%M%S`.sql

docker exec -t pm-database-dev pg_dump -c -U pm pm > $FILENAME
