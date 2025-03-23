from OdooLocust.OdooLocustUser import OdooLocustUser

# Override the OdooLocustUser class to fix the hostname issue
# When using OdooLocustUser with a host that contains a protocol (http://) or a
# port number, the connection to Odoo fails with an error like:
# "HTTPConnectionPool(host='http', port=80): Max retries exceeded with url: /localhost:8069:8069/jsonrpc".
# This happens because odoolib.get_connection() expects the hostname parameter
# to be just the hostname without any protocol or port, but Locust sets the host
# parameter with a URL format.

class MainOdooLocustUser(OdooLocustUser):
    abstract = True

    def on_start(self):
        # Clean up the hostname before connecting
        # Remove any protocol and port that might be in the hostname
        if self.host and "//" in self.host:
            self.host = self.host.split("//")[-1]

        if self.host and ":" in self.host:
            self.host = self.host.split(":")[0]

        # Call the parent on_start method with the cleaned hostname
        super().on_start()