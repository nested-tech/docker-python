FROM python:3.6-stretch

RUN apt-get update
RUN apt-get install -yq build-essential git libstdc++6 liblapack-dev gcc musl-dev
RUN apt-get install -yq postgresql postgresql-contrib libpq-dev

# Install Dockerize: it's useful (e.g. when telling a container to wait for its postgres
# database to start up)
# https://github.com/jwilder/dockerize#ubuntu-images
RUN apt-get install -yq wget
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Get poetry so we can manage python dependencies in a goodish way
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3

# Create dir for poetry virtualenvs and pip base virtualenv
RUN mkdir -p /root/poetry_venvs

# Some projects will expect poetry venvs to be here, and so will cache this dir on CI
RUN poetry config virtualenvs.path /root/poetry_venvs

# It's always good practice to use a virtualenv, so we create one beforehand.
RUN python3 -m venv /root/virtualenv

RUN /root/virtualenv/bin/pip install 'wheel ~= 0.30'

# Some standard utilities we need for checking code.
RUN /root/virtualenv/bin/pip install 'pylint ~= 1.7' 
RUN /root/virtualenv/bin/pip install 'pytest ~= 3.1' 
RUN /root/virtualenv/bin/pip install 'pytest-cov ~= 2.5'

ADD pylintrc /root/pylintrc
ADD run_tests /root/run_tests

