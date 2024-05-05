#!/usr/bin/python3
"""Script to start a Flask web application"""

from flask import Flask, render_template
from models import storage
from models.state import State
from models.city import City
from models.amenity import Amenity

app = Flask(__name__)


@app.route('/hbnb_filters', strict_slashes=False)
def hbnb_filters():
    """Display the HBNB filters HTML page"""
    states = storage.all(State).values()
    sorted_states = sorted(states, key=lambda x: x.name)
    cities = storage.all(City).values()
    sorted_cities = sorted(cities, key=lambda x: x.name)
    amenities = storage.all(Amenity).values()
    sorted_amenities = sorted(amenities, key=lambda x: x.name)
    return render_template('10-hbnb_filters.html',
                           states=sorted_states, cities=sorted_cities,
                           amenities=sorted_amenities)


@app.teardown_appcontext
def teardown(exception):
    """Remove the current SQLAlchemy Session"""
    storage.close()


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
