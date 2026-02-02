#!/usr/bin/env bash

DATE="$(date +%F)"
DATETIME="$(date +'%Y/%m/%d %H:%M:%S')"
BU_HOME=~/pm/backup
FILENAME=$BU_HOME/pm-backup`date +%Y%m%d"-"%H%M%S`.sql
DOW=$(date +%u)
recipients="ruud@vliet.io"
FAILED=false

# create the backup
docker exec -t pm-database pg_dump -c -U pm pm > $FILENAME
if [ $? -ne 0 ]; then FAILED=true; fi

if [ "$FAILED" = false ]; then
	# upload it to Google drive
	rclone copy -v $FILENAME 'gdrive:PlusMin/pm-backup' >>  $BU_HOME/pm_backup.log 2>&1
	if [ $? -ne 0 ]; then FAILED=true; fi
fi

if [ "$FAILED" = false ]; then
	# rm all backup files older than 7 days
	find $BU_HOME -type f -mtime +7 -name "*.sql" | xargs rm >>  $BU_HOME/pm_backup.log 2>&1
fi

if [ "$FAILED" = false ]; then
  if [ $DOW -eq 1 ]; then
    printf "To: $recipients\nFrom: ruud@vliet.io\nSubject: GEEN ERRORs bij backup: wekelijkse rapportage van de pm-backend backup check op $DATE\n\nGeen ERRORs in de backup\n" >$BU_HOME/bu-mail.txt
    ssmtp $recipients < $BU_HOME/bu-mail.txt
    printf "%s Mail verzonden naar %s...\n\n\n" "$DATETIME" "$recipients" >> "$BU_HOME/pm_backup.log"
  else
    printf "%s GEEN mail verzonden naar %s...\n\n\n" "$DATETIME" "$recipients" >> "$BU_HOME/pm_backup.log"
  fi
else
  printf "To: $recipients\nFrom: ruud@vliet.io\nSubject: ERRORs in de pm-backend backup op $DATE\n\n" >$BU_HOME/bu-mail.txt
  cat $BU_HOME/pm_backup.log >> $BU_HOME/bu-mail.txt
  ssmtp $recipients < $BU_HOME/bu-mail.txt
  printf "%s Mail verzonden naar %s...\n\n\n" "$DATETIME" "$recipients" >> "$BU_HOME/pm_backup.log"
fi
