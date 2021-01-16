#!/bin/sh

TEMPERATURE_FILE="$(dirname "$(readlink -f "$0")")/metrics"
SLEEP_SECONDS=60

# GIT_SSH_COMMAND="ssh -i ~/.ssh/id_rsa_example"
# export GIT_SSH_COMMAND
# git config core.sshCommand "ssh -i ~/.ssh/id_rsa_example -F /dev/null"

while true; do
	echo '# HELP temperature Temperature from sensor' > $TEMPERATURE_FILE
	echo '# TYPE temperature gauge' >> $TEMPERATURE_FILE
	temper-poll | sed -n 's/Device.*: *\(.*\)°C *\(.*\)°F.*$/temperature{unit="C",} \1\ntemperature{unit="F",} \2/p' >> $TEMPERATURE_FILE

	git add $TEMPERATURE_FILE
	git commit -m "$(date --iso-8601=seconds)"
	git push

	sleep $SLEEP_SECONDS

	git fetch origin
	git reset --hard origin/main
done
