#!/bin/sh

set -o nounset
set -o errexit

TEMPERATURE_FILE=/srv/www/metrics/temperature
TMP_FILE="$(dirname "$(readlink -f "$0")")/metrics.tmp"

echo '# HELP temperature Temperature from sensor' > "${TMP_FILE}"
echo '# TYPE temperature gauge' >> "${TMP_FILE}"
temper-poll | sed -n 's/Device.*: *\(.*\)°C *\(.*\)°F.*$/temperature{unit="C",} \1\ntemperature{unit="F",} \2/p' >> "${TMP_FILE}"
echo '# HELP updated Time stamp of update' >> "${TMP_FILE}"
echo '# TYPE updated counter' >> "${TMP_FILE}"
echo "updated $(date +%s)" >> "${TMP_FILE}"

cat "${TMP_FILE}" > "${TEMPERATURE_FILE}"
rm "${TMP_FILE}"
