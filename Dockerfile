FROM python:3.6

RUN apt-get update
RUN apt-get install -yq build-essential git libstdc++6 liblapack-dev gcc musl-dev
RUN apt-get install -yq postgresql postgresql-contrib libpq-dev

# It's always good practice to use a virtualenv, so we create one beforehand.
RUN mkdir -p /root
RUN python3 -m venv /root/virtualenv

# Some standard utilities we need for checking code.
RUN /root/virtualenv/bin/pip install 'pylint ~= 1.7' 
RUN /root/virtualenv/bin/pip install 'pytest ~= 3.1' 
RUN /root/virtualenv/bin/pip install 'pytest-cov ~= 2.5'

ADD pylintrc /root/pylintrc
ADD run_tests /root/run_tests

