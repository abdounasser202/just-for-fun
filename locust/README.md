# Odoo performance testing with Locust

This setup uses a Docker container with [OdooLocust](https://pypi.org/project/OdooLocust/) for Odoo performance testing.

## Running Locust

Make the locust.sh script executable:

```bash
chmod +x locust.sh
```

Building the Locust docker image

```bash
./locust.sh buid 
```

To stop the running Locust container

```bash
./locust.sh stop 
```

To run Locust with its default parameters

```bash
./locust.sh run [PARAMETERS] 
```

**PARAMETERS**

- -u, --users: Number of concurrent users
- -r, --spawn-rate: Rate at which users are spawned
- -t, --run-time: Stop after the specified time
- --csv: Store results in CSV format
- --headless: Run without web UI
- --only-summary: Only print summary stats
- --html: Generate HTML report

**Examples**

Basic usage with just the host

```bash
./locust.sh run
```

Specify number of users and spawn rate

```bash
./locust.sh run -u 100 -r 10
```

Run in headless mode for a specific time

```bash
./locust.sh run -H http://localhost:8069 --headless -u 50 -r 5 -t 10m
```

Specify a custom locustfile

```bash
./locust.sh run -f /mnt/locust/my_test.py -H http://localhost:8069
```

Run with CSV output

```bash
./locust.sh run -H http://localhost:8069 --csv=results
```

Combine multiple parameters

```bash
./locust.sh run -H http://localhost:8069 -u 200 -r 20 --csv=test_results --html=report.html
```

Run in detached mode with custom parameters

```bash
./locust.sh run -d -H http://localhost:8069 -u 50 -r 10 --run-time 5m
```

## Important Notes

1. The script connects to the Odoo instance using `http://localhost:8069`

2. Do not forget to modify the host URL or connect the Locust container to the Odoo container network.

3. The Locust web interface is available at: http://localhost:8089

## Odoo Performance Testing Best Practices

1. Test with realistic data volumes
2. Focus on workflows users actually perform
3. Include database-intensive operations
4. Test multistep business processes
5. stability is different from performance
6. Monitor server resources during testing (Prometheus, Grafana)
