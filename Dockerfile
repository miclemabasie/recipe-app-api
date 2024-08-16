FROM python:3.10.0-slim-buster
LABEL maintainer="techwithmiclem.com"
ENV PYTHONUNBUFFERED=1


COPY ./app /app
WORKDIR /app
EXPOSE 8000

# Install dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    gettext \
    netcat \
    gcc \
    postgresql \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/*

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

ARG DEV=false

# Setup Python environment
RUN python -m venv /py && \
    /py/bin/python -m pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [$DEV = "true"]; \
    then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm /tmp/requirements.txt

ENV PATH="/py/bin:$PATH"


