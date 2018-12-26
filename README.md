## Image classification REST API

A simple REST API that uses a pre-trained Keras model to classify images from URL's.

#### Deployment

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

Deploy to AWS using [Zappa](https://github.com/Miserlou/Zappa):
```bash
pip install zappa
zappa deploy api
```
