from flask import Flask, jsonify, request
from keras import backend
from keras.applications.xception import Xception, preprocess_input, decode_predictions
from keras.preprocessing import image
from PIL import Image

import boto3
import numpy as np
import os
import requests

app = Flask(__name__)
app.config['JSON_SORT_KEYS'] = False


def classify_image(url, top):

    bucket = boto3.resource('s3').Bucket(os.environ.get('S3_BUCKET'))
    bucket.download_file('xception_weights_tf_dim_ordering_tf_kernels.h5', '/tmp/weights.h5')

    model = Xception(weights='/tmp/weights.h5')

    img_raw = requests.get(url, stream=True).raw
    img = Image.open(img_raw)
    img = img.resize(size=(224, 224))

    x = image.img_to_array(img)
    x = np.expand_dims(x, axis=0)
    x = preprocess_input(x)

    preds = model.predict(x)
    preds_top = decode_predictions(preds, top=top)[0]
    backend.clear_session()

    return {i[1]: str(i[2]) for i in preds_top}


@app.route('/')
def index():
    return 'Home'


@app.route('/predict')
def predict():
    url = request.args.get('url')
    if not url:
        return jsonify({'error': 'No URL specified'}), 400
    top = request.args.get('n', default=3, type=int)
    return jsonify(classify_image(url=url, top=top)), 200


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
