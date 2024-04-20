#!/usr/bin/python3
"""Script to start a Flask web application"""

from flask import Flask, render_template
from models import storage
from models.state import State
from models.city import City
from operator import attrgetter

app = Flask(__name__)


@app.route('/states', strict_slashes=False)
def states():
    """Display a list of all State objects present in DBStorage"""
    states = storage.all(State).values()
    sorted_states = sorted(states, key=attrgetter('name'))
    return render_template('9-states.html', states=sorted_states)


@app.route('/states/<id>', strict_slashes=False)
def states_cities(id):
    """Display details of a specific State object"""
    state = storage.get(State, id)
    if state:
        cities = sorted(state.cities, key=attrgetter('name'))
        return render_template('9-states_cities.html', state=state, cities=cities)
    else:
        return render_template('9-not_found.html')


@app.teardown_appcontext
def teardown(exception):
    """Remove the current SQLAlchemy Session"""
    storage.close()


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
