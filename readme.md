# Local Temperature Exporter

A simple shell script using
[temper-python](https://github.com/padelt/temper-python) to obtain temperatures
and putting them into a metrics file that can be delivered via a web server
like Nginx or Apache and be picked up by [Prometheus](https://prometheus.io).


## Requirements

Make sure the following tools are installed:

- [temper-python](https://github.com/padelt/temper-python)
