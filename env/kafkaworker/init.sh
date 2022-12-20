#!/bin/sh

until /bin/nc -z -v -w30 ${AIRSEND_CLOUD_DB_ADDRESS} ${AIRSEND_DB_PORT}
do
  echo "Waiting for database to be up..."
  sleep 1
done

#until /bin/nc -z -v -w30 ${AIRSEND_INTERNAL_KAFKA_HOST} ${AIRSEND_INTERNAL_KAFKA_PORT}
#do
#  echo "Waiting for kafka to be up..."
#  sleep 1
#done

runuser -u www-data -- /usr/local/bin/php worker/index.php --groupid=parallelbackgrounders --topic=${TOPIC} --priority=${PRIORITY}
