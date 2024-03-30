from flask_wtf import FlaskForm
from wtforms import StringField, DecimalField, DateField
from wtforms.validators import DataRequired, NumberRange


class RecommendationForm(FlaskForm):
    destination = StringField('Destination', validators=[DataRequired()])
    budget = DecimalField('Budget', validators=[DataRequired(), NumberRange(min=0)])
    dates = DateField('Dates de voyage', format='%Y-%m-%d', validators=[DataRequired()])
    activities = StringField('Activités', validators=[DataRequired()])

    @classmethod
    def from_json(cls, data):
        form = cls()
        form.destination.data = data.get('destination')
        form.budget.data = float(data.get('budget'))
        form.dates.data = data.get('dates')
        form.activities.data = data.get('activities')
        return form
