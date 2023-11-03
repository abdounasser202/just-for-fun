from flask import Blueprint

module = Blueprint("funpill", __name__, url_prefix="/funpill",
                   template_folder="views", static_folder="assets")
