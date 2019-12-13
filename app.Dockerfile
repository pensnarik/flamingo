FROM tiangolo/uwsgi-nginx-flask:python3.7

RUN pip3 install psycopg2 Flask-Login requests

COPY ./flamingo /app/flamingo
COPY ./tests /app/tests
COPY ./bin /app/bin
COPY ./test-shop /app/test-shop
COPY flamingo.config.docker /app/flamingo.config
COPY prestart.sh /app/prestart.sh
ENV UWSGI_INI /app/flamingo/uwsgi.ini
ENV NGINX_MAX_UPLOAD 10m
ENV STATIC_PATH /app/flamingo/static