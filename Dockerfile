FROM python:3.6

COPY ./ /home/

RUN apt-get update -y && apt-get install nginx supervisor -y

RUN rm /etc/nginx/sites-enabled/default && \
        mv /home/nginx.conf /etc/nginx/conf.d/ && \
        echo "daemon off;" >> /etc/nginx/nginx.conf && \
        mv /home/supervisord.conf /etc/supervisor/conf.d/ && \
        mkdir -p /var/log/flaskapi && \
        touch /var/log/flaskapi/flaskapi.err.log && \
        touch /var/log/flaskapi/flaskapi.out.log

RUN pip install --no-cache-dir -r /home/requirements.txt && pip install gunicorn

CMD ["supervisord", "--configuration", "/etc/supervisor/supervisord.conf"]
