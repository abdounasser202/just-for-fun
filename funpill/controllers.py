import imp
from flask import render_template
from .blueprint import module


@module.route("/")
def play_funpill():
    return render_template("funpill.html")
