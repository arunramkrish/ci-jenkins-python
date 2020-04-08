FROM tiangolo/uwsgi-nginx-flask:python3.6-alpine3.7
RUN apk --update add bash nano
ENV STATIC_URL /static
ENV STATIC_PATH /var/www/app/static
COPY ./requirements.txt /var/www/requirements.txt
COPY ./requirements/*.txt /var/www/requirements/
COPY ./app.py /var/www/app.py
WORKDIR /var/www
RUN pip install -r ./requirements.txt
RUN pip install flask
ENTRYPOINT ["python","/var/www/app.py"]
EXPOSE 5555