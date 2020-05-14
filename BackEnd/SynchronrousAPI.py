# flask overview: https://flask.palletsprojects.com/en/1.1.x/
# flask installation: https://flask.palletsprojects.com/en/1.1.x/installation/#python-version
# maybe it might be easier to use a framework like hug

import logging
from flask import Flask, request
import face_id
import time
import sys

# creates the basic flask routing
app = Flask(__name__)

@app.route('/')
def hello_world():
    return "Hello World"

async def test():
    print("Hello World")

@app.route('/add_new_person', methods=['POST'])
def add_new_person():
    request_body = request.get_json()
    name = request_body['name']
    image_stream = request_body['image']
    value = face_id.add_face_with_stream(name, image_stream)
    return value

@app.route('/list', methods=['GET'])
def get_list():
    # read the database and return the required information
    pass

@app.route('/train', methods=['POST'])
def train():
    # will be called every 24 hours or every time that an image is added
    # read through all the images in the centralized database
    return "training in progress"

# creates the routing for the server
@app.route('/analyze', methods = ['POST'])
def analyze():
    request_body = request.get_json()
    image_stream = request_body['image']
    face_identification = face_id.get_face_from_stream(image_stream)
    value = face_id.identify_person(face_identification)
    return value

def face_api():
    return "test"

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0')