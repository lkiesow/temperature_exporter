# Local Temperature Exporter

A simple shell script using
[temper-python](https://github.com/padelt/temper-python) to obtain temperatures
from a server, uploading them to an S3 compatible public storage so that they
can be picked up by [ptomrzhrud](https://prometheus.io).


## Requirements

Make sure the following tools are installed:

- [temper-python](https://github.com/padelt/temper-python)
- [s3cmd](https://s3tools.org/s3cmd)


## Configuration

Cpnfigure s3cmd by copying and modifying the example configuration:

```
cp s3cfg.template s3cfg
vim s3cfg
```

You can also configure the update frequency and bucket to use at the top of the `temp.sh` file:

```sh
TEMPERATURE_FILE="$(dirname "$(readlink -f "$0")")/metrics"
S3CFG_FILE="$(dirname "$(readlink -f "$0")")/s3cfg"
S3_LOCATION="sensors/temperature-server/metrics"
SLEEP_SECONDS=60
```
