#!/usr/bin/env bash

# create a security group
aws ec2 create-security-group --group-name my-sg --description "My security group"
SECURITY_GROUP_ID=$(aws ec2 describe-security-groups --group-name my-sg --query "SecurityGroups[*].GroupId" --output=text)

aws ec2 authorize-security-group-ingress --group-id ${SECURITY_GROUP_ID} --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id ${SECURITY_GROUP_ID} --protocol tcp --port 80 --cidr 0.0.0.0/0

# create an ec2 instance
aws ec2 run-instances \
    --image-id ami-0274e11dced17bb5b \
    --count 1 \
    --instance-type t2.micro \
    --key-name my_key \
    --security-group-ids ${SECURITY_GROUP_ID}

PUBLIC_IP=$(aws ec2 describe-instances \
            --query "Reservations[*].Instances[*].PublicIpAddress" \
            --output=text)

# install git and docker
ssh -T -i ~/.ssh/my_key.pem -o StrictHostKeyChecking=no ec2-user@${PUBLIC_IP} << EOF
    sudo yum update -y && \
        sudo yum install git -y && \
        sudo amazon-linux-extras install docker -y && \
        sudo service docker start && \
        sudo usermod -a -G docker ec2-user
EOF

# clone repo
ssh -T -i ~/.ssh/my_key.pem ec2-user@${PUBLIC_IP} << EOF
    git clone https://github.com/imrankhan17/deep-learning-api.git && \
        cd deep-learning-api && \
        curl -LOk https://github.com/fchollet/deep-learning-models/releases/download/v0.4/xception_weights_tf_dim_ordering_tf_kernels.h5
EOF

# start docker container
ssh -T -i ~/.ssh/my_key.pem ec2-user@${PUBLIC_IP} << EOF
    cd deep-learning-api && \
    docker build -t keras-rest-api . && \
        docker run -it -d -p 80:80 keras-rest-api
EOF

echo ${PUBLIC_IP}
