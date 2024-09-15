# app.py

from flask import Flask, render_template, request, redirect, url_for, send_file
from flask_sqlalchemy import SQLAlchemy
from flask_login import (
    LoginManager,
    UserMixin,
    login_user,
    login_required,
    logout_user,
    current_user,
)
from werkzeug.security import generate_password_hash, check_password_hash
import os
import markdown
import stripe

app = Flask(__name__)
app.config["SECRET_KEY"] = "your-secret-key"
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///ebooks.db"
app.config["UPLOAD_FOLDER"] = "ebooks"
stripe.api_key = "your-stripe-secret-key"

db = SQLAlchemy(app)
login_manager = LoginManager(app)
login_manager.login_view = "login"


class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(128))
    purchases = db.relationship("Purchase", backref="user", lazy=True)


class Ebook(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    price = db.Column(db.Float, nullable=False)
    folder_name = db.Column(db.String(100), nullable=False)


class Purchase(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable=False)
    ebook_id = db.Column(db.Integer, db.ForeignKey("ebook.id"), nullable=False)


@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))


@app.route("/")
def index():
    ebooks = Ebook.query.all()
    return render_template("index.html", ebooks=ebooks)


@app.route("/ebook/<int:ebook_id>")
def ebook_detail(ebook_id):
    ebook = Ebook.query.get_or_404(ebook_id)
    return render_template("ebook_detail.html", ebook=ebook)


@app.route("/buy/<int:ebook_id>", methods=["POST"])
@login_required
def buy_ebook(ebook_id):
    ebook = Ebook.query.get_or_404(ebook_id)
    # Create Stripe Checkout session
    session = stripe.checkout.Session.create(
        payment_method_types=["card"],
        line_items=[
            {
                "price_data": {
                    "currency": "usd",
                    "product_data": {
                        "name": ebook.title,
                    },
                    "unit_amount": int(ebook.price * 100),
                },
                "quantity": 1,
            }
        ],
        mode="payment",
        success_url=url_for("payment_success", ebook_id=ebook.id, _external=True),
        cancel_url=url_for("index", _external=True),
    )
    return redirect(session.url, code=303)


@app.route("/payment_success/<int:ebook_id>")
@login_required
def payment_success(ebook_id):
    purchase = Purchase(user_id=current_user.id, ebook_id=ebook_id)
    db.session.add(purchase)
    db.session.commit()
    return redirect(url_for("my_ebooks"))


@app.route("/my_ebooks")
@login_required
def my_ebooks():
    purchases = Purchase.query.filter_by(user_id=current_user.id).all()
    return render_template("my_ebooks.html", purchases=purchases)


@app.route("/read_ebook/<int:ebook_id>/<int:chapter>")
@login_required
def read_ebook(ebook_id, chapter):
    ebook = Ebook.query.get_or_404(ebook_id)
    purchase = Purchase.query.filter_by(
        user_id=current_user.id, ebook_id=ebook_id
    ).first()
    if not purchase:
        return "You don't have access to this ebook", 403

    chapter_file = f"chap_{chapter}.md"
    chapter_path = os.path.join(
        app.config["UPLOAD_FOLDER"], ebook.folder_name, chapter_file
    )

    if not os.path.exists(chapter_path):
        return "Chapter not found", 404

    with open(chapter_path, "r") as file:
        content = file.read()
        html_content = markdown.markdown(content)

    return render_template(
        "read_chapter.html", ebook=ebook, chapter=chapter, content=html_content
    )


@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        user = User.query.filter_by(username=request.form["username"]).first()
        if user and check_password_hash(user.password_hash, request.form["password"]):
            login_user(user)
            return redirect(url_for("index"))
    return render_template("login.html")


@app.route("/logout")
@login_required
def logout():
    logout_user()
    return redirect(url_for("index"))


@app.route("/register", methods=["GET", "POST"])
def register():
    if request.method == "POST":
        hashed_password = generate_password_hash(request.form["password"])
        new_user = User(
            username=request.form["username"],
            email=request.form["email"],
            password_hash=hashed_password,
        )
        db.session.add(new_user)
        db.session.commit()
        return redirect(url_for("login"))
    return render_template("register.html")


if __name__ == "__main__":
    with app.app_context():
        db.create_all()
    app.run(debug=True)
