set -e

ONEMINUTECRONDIR="/etc/periodic/1min"
FIVEMINUTECRONDIR="/etc/periodic/5min"
THIRTYMINUTECRONDIR="/etc/periodic/30min"

if [ ! -d "$ONEMINUTECRONDIR" ]; then

  mkdir /etc/periodic/1min
  crontab -l | { echo "*       *       *       *       *       run-parts /etc/periodic/1min"; cat; } | crontab -

fi

if [ ! -d "$FIVEMINUTECRONDIR" ]; then

  mkdir /etc/periodic/5min
  crontab -l | { echo "*/5     *       *       *       *       run-parts /etc/periodic/5min"; cat; } | crontab -

fi

if [ ! -d "$THIRTYMINUTECRONDIR" ]; then

  mkdir /etc/periodic/30min
  crontab -l | { echo "*/30     *       *       *       *       run-parts /etc/periodic/30min"; cat; } | crontab -

fi

CRONDIR="/data/cron/"

if [ -d "$CRONDIR" ]; then
  echo "Cron directory exist."
else
  echo "Create cron directory ..."
  mkdir -p /data/cron
  echo "Cron directory created."

fi

if [ -d "/data/cron/1min" ]; then
  echo "Cron 1 min directory exist."
else
  mkdir -p /data/cron/1min
  echo "Cron 1 min directory created."
fi
if [ -d "/data/cron/5min" ]; then
  echo "Cron 5 min directory exist."
else
  mkdir -p /data/cron/5min
  echo "Cron 5 min directory created."
fi
if [ -d "/data/cron/15min" ]; then
  echo "Cron 15 min directory exist."
else
  mkdir -p /data/cron/15min
  echo "Cron 15 min directory created."
fi
if [ -d "/data/cron/30min" ]; then
  echo "Cron 30 min directory exist."
else
  mkdir -p /data/cron/30min
  echo "Cron 30 min directory created."
fi
if [ -d "/data/cron/hourly" ]; then
  echo "Cron hourly directory exist."
else
  mkdir -p /data/cron/hourly
  echo "Cron hourly directory created."
fi
if [ -d "/data/cron/daily" ]; then
  echo "Cron daily directory exist."
else
  mkdir -p /data/cron/daily
  echo "Cron daily directory created."
fi
if [ -d "/data/cron/weekly" ]; then
  echo "Cron weekly directory exist."
else
  mkdir -p /data/cron/weekly
  echo "Cron weekly directory created."
fi
if [ -d "/data/cron/monthly" ]; then
  echo "Cron monthly directory exist."
else
  mkdir -p /data/cron/monthly
  echo "Cron monthly directory created."
fi

rm -rf /etc/periodic/1min
rm -rf /etc/periodic/5min
rm -rf /etc/periodic/15min
rm -rf /etc/periodic/30min
rm -rf /etc/periodic/hourly
rm -rf /etc/periodic/daily
rm -rf /etc/periodic/weekly
rm -rf /etc/periodic/monthly

ln -s /data/cron/1min /etc/periodic/1min
ln -s /data/cron/5min /etc/periodic/5min
ln -s /data/cron/15min /etc/periodic/15min
ln -s /data/cron/30min /etc/periodic/30min
ln -s /data/cron/hourly /etc/periodic/hourly
ln -s /data/cron/daily /etc/periodic/daily
ln -s /data/cron/weekly /etc/periodic/weekly
ln -s /data/cron/monthly /etc/periodic/monthly
