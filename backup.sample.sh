#!/bin/sh

export REPOSITORY='/media/external-hdd/backup'

if [ ! -d "$REPOSITORY" ]; then
  echo "Backup drive is not connected."
  exit
fi

#Bail if borg is already running, maybe previous run didn't finish
if pidof -x borg >/dev/null; then
    echo "Backup already running"
    exit
fi

echo "Starting backup"
set -x
borg create \
  -v --stats --filter AME --list --compression lz4 --exclude-caches \
  $REPOSITORY::'{hostname}-{now:%Y-%m-%d}' /home/media /home/samba /home/zveljkovic /home/smiljana
set +x
backup_exit=$?

echo "Pruning repository"
borg prune -v --list $REPOSITORY --prefix '{hostname}-' --keep-monthly=1
prune_exit=$?

echo "Compacting repository"
borg compact $REPOSITORY
compact_exit=$?

# use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))
global_exit=$(( compact_exit > global_exit ? compact_exit : global_exit ))

if [ ${global_exit} -eq 0 ]; then
    echo "Backup, Prune, and Compact finished successfully"
elif [ ${global_exit} -eq 1 ]; then
    echo "Backup, Prune, and/or Compact finished with warnings"
else
    echo "Backup, Prune, and/or Compact finished with errors"
fi

exit ${global_exit}
