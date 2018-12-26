## Image classification REST API

A simple REST API that uses a pre-trained Keras model to classify images from URL's.

#### Setup

Clone the repo:
```bash
git clone https://github.com/imrankhan17/deep-learning-api.git
cd deep-learning-api
```

Create a virtual environment:
```bash
python3 -m venv env
source env/bin/activate
pip install -r requirements.txt
```

You will need to download the _Xception_ model weights from [here](https://github.com/fchollet/deep-learning-models/releases/download/v0.4/xception_weights_tf_dim_ordering_tf_kernels.h5) and store them in an S3 bucket.  The name of this bucket should be inserted into line 6 of `zappa_settings.json`.  You will also need to change the name of the S3 bucket in line 24 to something random.

#### Deployment

Deploy to AWS using [Zappa](https://github.com/Miserlou/Zappa):
```bash
pip install zappa
zappa deploy api
```
