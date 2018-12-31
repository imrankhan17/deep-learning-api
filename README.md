## Image classification REST API

A simple REST API that uses a pre-trained Keras model to classify images from URL's.

#### Setup

Clone the repo:
```bash
git clone https://github.com/imrankhan17/deep-learning-api.git
cd deep-learning-api
```

Download the _Xception_ model weights:
```bash
curl -LOk https://github.com/fchollet/deep-learning-models/releases/download/v0.4/xception_weights_tf_dim_ordering_tf_kernels.h5
```

#### Deployment

Build the Docker image:
```bash
docker build -t keras-rest-api .
```

Start a container:
```bash
docker run -it -d -p 80:80 keras-rest-api
```

#### Usage

```bash
curl http://{public IP of VM instance}/predict?n=10&url=https://images-na.ssl-images-amazon.com/images/I/71gdBQP%2BqGL._UY445_.jpg
```
