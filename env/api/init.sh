#!/bin/sh

COMPOSER="composer --working-dir=/var/www/dev -n"

# Ensure composer install on init...
$COMPOSER install

# Run database init scripts (no fresh flag, so we don't recreate the data on each env init)
until nc -z -v -w30 db 3306
do
  echo "Waiting for database connection..."
  sleep 1
done
$COMPOSER run asclouddbinit -- --hide-script-info
$COMPOSER run asstoragedbinit -- --hide-script-info

# Populate the database with simple test data (script skips it when already populated)
$COMPOSER run clsetup -- --hide-script-info

# Generate oauth files if they don't exists
PRIVATE_KEY_FILE="/var/www/dev/resources/oauth/private.key"
if [ ! -f "$PRIVATE_KEY_FILE" ]; then
    openssl genrsa -out $PRIVATE_KEY_FILE 2048
    chmod 600 $PRIVATE_KEY_FILE
    chown www-data: $PRIVATE_KEY_FILE
fi

PUBLIC_KEY_FILE="/var/www/dev/resources/oauth/public.key"
if [ ! -f "$PUBLIC_KEY_FILE" ]; then
  openssl rsa -in $PRIVATE_KEY_FILE -pubout -out $PUBLIC_KEY_FILE
  chmod 600 $PUBLIC_KEY_FILE
  chown www-data: $PUBLIC_KEY_FILE
fi

# Run indexing for search
until nc -z -v -w30 elasticsearch 9200
do
  echo "Waiting for elastic search connection..."
  sleep 1
done
$COMPOSER run index -- --hide-script-info

# Init the service
php-fpm