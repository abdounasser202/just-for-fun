import openai
from configparser import ConfigParser
from flask import Flask, request, render_template, redirect, jsonify, \
    abort, flash
from flask_wtf.csrf import CSRFProtect
from flask_talisman import Talisman

from forms import RecommendationForm

app = Flask(__name__)
config = ConfigParser()
config.read('config.ini')
app.config['SECRET_KEY'] = config.get('secret', 'secret_key')
csrf = CSRFProtect(app)
Talisman(app)


# Configure the OpenAI API with a valid API key
openai.api_key = config.get('secret', 'api_key')


# Define the route to render the index page with the form
@app.route('/', methods=['GET'])
def index():
    form = RecommendationForm()
    return render_template('home.html', form=form)


# Define the route to handle form submissions
@app.route('/recommend', methods=['POST'])
@csrf.exempt
def recommend():
    if request.is_json:
        try:
            form_data = request.get_json()
            form = RecommendationForm.from_json(form_data)
            if form.validate():
                destination = form.destination.data
                budget = form.budget.data
                dates = form.dates.data
                activities = form.activities.data

                # Call the GPT-3 API to generate recommendations for travel destinations
                response = openai.Completion.create(
                    engine="text-davinci-002",
                    prompt=f"Je veux voyager à {destination} avec un budget de {budget} euros en {dates} et j'aime faire {activities}.",
                    max_tokens=150,
                    n=3,
                    stop=None,
                    temperature=0.5
                )

                # Retrieve the results from the GPT-3 API and format them for display in the UI
                results = [choice.text.strip() for choice in response.choices]
                return jsonify(results)

        except Exception as e:
            abort(500, f"Error: {e}")

        errors = form.errors
        flash("Please correct the following errors: {}".format(errors), "error")
    else:
        errors = {"message": "Invalid content-type, expected application/json."}
        flash(errors["message"], "error")

    return jsonify({'errors': errors})


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8000)
