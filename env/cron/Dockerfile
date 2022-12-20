FROM php:7.2

RUN apt-get clean && apt-get update

RUN apt-get install -y cron

# Copy crontab file into the container
COPY crontab /crontab

# Apply cron job
RUN crontab /crontab

# Run the command on container startup
CMD env >/cronenv && cron -f