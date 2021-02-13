#!/bin/sh

set -o nounset
set -o errexit

TEMPERATURE_FILE="$(dirname "$(readlink -f "$0")")/metrics"
S3CFG_FILE="$(dirname "$(readlink -f "$0")")/s3cfg"
S3_LOCATION="sensors/temperature-server/metrics"
SLEEP_SECONDS=60

if [ ! -f "${S3CFG_FILE}" ]; then
  echo "Error: Configuration for s3cmd is missing."
  echo "       Expecting it to be at ${S3CFG_FILE}."
  exit 1
fi

while true; do
  echo '# HELP temperature Temperature from sensor' > "${TEMPERATURE_FILE}.tmp"
  echo '# TYPE temperature gauge' >> "${TEMPERATURE_FILE}.tmp"
  temper-poll | sed -n 's/Device.*: *\(.*\)°C *\(.*\)°F.*$/temperature{unit="C",} \1\ntemperature{unit="F",} \2/p' >> "${TEMPERATURE_FILE}.tmp"

  if diff -q "${TEMPERATURE_FILE}" "${TEMPERATURE_FILE}.tmp"; then
    rm "${TEMPERATURE_FILE}.tmp"
  else
    mv "${TEMPERATURE_FILE}.tmp" "${TEMPERATURE_FILE}"
    s3cmd -c "${S3CFG_FILE}" put "${TEMPERATURE_FILE}" "s3://${S3_LOCATION}"
  fi

  sleep $SLEEP_SECONDS
done
