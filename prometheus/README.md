# Prometheus

https://prometheus.io/docs/introduction/overview/

Run Prometheus from docker

Command-line flags that configure how Prometheus runs inside the Docker container:

--config.file=/etc/prometheus/prometheus.yml

Specifies the location of the Prometheus configuration file : tells Prometheus where to find its main configuration that defines what to monitor and how


--storage.tsdb.path=/prometheus

Sets the directory where Prometheus will store its time-series database (TSDB) where all the metrics data gets saved persistently


--web.console.libraries=/etc/prometheus/console_libraries

Defines the path to the console library files: JavaScript libraries used by the Prometheus web UI


--web.console.templates=/etc/prometheus/consoles

Sets the path to the console template files: help format the data displayed in the Prometheus web interface


--web.enable-lifecycle

Enables the HTTP API endpoints for lifecycle management to reload Prometheus configuration without restarting the container