from bottle import route, run, template, redirect, static_file


@route("/")
def index():
    return redirect("wanalytics")


@route("/wanalytics")
def wanalytics():
    return template("wanalytics.html")


@route("/static/<filename:path>")
def send_static(filename):
    return static_file(filename, root="./static")


run(reloader=True)
