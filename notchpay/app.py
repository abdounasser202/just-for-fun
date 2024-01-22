import uuid
import hashlib
import requests
import logging

from flask import Flask, abort, redirect, request

app = Flask(__name__)
logger = logging.getLogger(__name__)


PUBLIC_KEY = "xxxx"
HASH_KEY = b"xxxx"
HTML_PAGE = """
<h1>Process payment</h1>
<a href="/pay">Pay Now</a>
"""


def initialize_payment(
    email, currency, amount, phone, reference, description, callback
):
    headers = {"Authorization": PUBLIC_KEY, "Accept": "application/json"}
    url = "https://api.notchpay.co/payments/initialize"
    data = {
        "email": email,
        "currency": currency,
        "amount": amount,
        "phone": phone,
        "reference": reference,
        "description": description,
        "callback": callback,
    }

    response = requests.post(url, headers=headers, data=data)

    if response.ok:
        json_response = response.json()
        return json_response
    else:
        return {"status_code": response.status_code, "msg": response.text}


def verify_payment(reference):
    url = f"https://api.notchpay.co/payments/{reference}"
    headers = {"Authorization": PUBLIC_KEY}

    response = requests.get(url, headers=headers)

    if response.ok:
        json_response = response.json()
        logger.debug(json_response)
        return json_response
    else:
        return {"status_code": response.status_code, "msg": response.text}


@app.route("/")
def home():
    return HTML_PAGE


@app.route("/pay")
def pay():
    payment_reference = uuid.uuid1()
    init_payment = initialize_payment(
        email="customersss@email.com",
        currency="XAF",
        amount="1500",
        phone=None,
        reference=payment_reference,
        description=f"Payment description {payment_reference}",
        callback=f"http://localhost:5000/verify", # make sure to have right host
    )
    return redirect(init_payment.get("authorization_url"))


@app.route("/verify")
def verify():
    reference = request.args.get("reference")
    return verify_payment(reference)


@app.route("/webhook", methods=["POST"])
def webhook():
    signature = request.headers.get("x-notch-signature")
    hash_value = hashlib.sha256(HASH_KEY).hexdigest()
    if hash_value == signature:
        try:
            json_data = request.get_json()
            logger.info("Webhook data:", json_data)
            return "", 200  # OK
        except Exception as e:
            logger.info("Error parsing JSON:", e)
            abort(400)  # Bad request
    else:
        logger.info("Webhook request could not be verified.")
        abort(403)  # Forbidden
