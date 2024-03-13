#!/bin/bash

set -x

DATESTR="`date +'%m%d%Y'`"
BACKUP_FILE="wks-backup-${DATESTR}.tgz"
BACKUP_PATH="/tmp/${BACKUP_FILE}"
EXCLUDE_FILE="${HOME}/work/backup/backup-exclude.txt"
#S3BUCKET="s3://tlowe-stuff-2"
export PATH=$PATH:/usr/local/bin
UID=$(echo $USER | cut -f2 -d '\')
BUCKET="tlowe-misc"
BUCKET_PATH="s3://${BUCKET}/wks-backups/$UID"

aws s3 sync --no-follow-symlinks \
--exclude '.gradle/*' \
--exclude '.rbenv/*' \
--exclude '.npm/_cacache/*' \
--exclude '.config/google-chrome/*' \
--exclude '.mozilla/firefox/*' \
--exclude '.config/Code/CachedData/*' \
--exclude '.config/Code/Cache/*' \
--exclude '.bundle/cache/*' \
--exclude '.cache/*' \
--exclude '.atom/compile-cache' \
--exclude 'src/projects/*' \
--exclude 'Downloads/*' \
--exclude 'bin/Postman/*' \
--exclude 'bin/terraform*' \
--exclude 'repos/*' \
--exclude '.config/Code/CachedData' \
--exclude '.config/Code/Cache' \
--exclude 'work/OH-Zips-SPF' \
--exclude 'work/PDMS-Zips' \
--exclude '.local/share/Trash' \
--exclude 'core*' \
. $BUCKET_PATH

# Exclude candidates:
# .vscode/extensions
# n/*
# src/devops

# Observations:
# exludes not working - work/PDMS-Zips/*, etc uploading...


exit 0
