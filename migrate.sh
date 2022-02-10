#!/usr/bin/env bash

#set -x

mysql -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD"

for i in {30..0}; do
    if echo 'SELECT 1' | mysql -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --ssl-mode=DISABLED &> /dev/null; then
        break
    fi
    echo 'MySQL init process in progress...'
    sleep 5
done

for f in /docker-entrypoint-migrations.d/migration*; do
    case "$f" in
        *.sql)    echo "$0: running $f"; mysql -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --ssl-mode=DISABLED "$MYSQL_DATABASE" < "$f"; echo ;;
        *.sql.gz) echo "$0: running $f"; gunzip -c "$f" | mysql -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --ssl-mode=DISABLED "$MYSQL_DATABASE"; echo ;;
        *)        echo "$0: ignoring $f" ;;
    esac
    echo
done
