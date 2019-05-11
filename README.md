# eps-values-api
One web api to query eps(Earnings per Share) values for listed companies, which is used to illustrate the use of ruby [eventmachine](https://github.com/eventmachine/eventmachine), [goliath](https://github.com/postrank-labs/goliath), [em-http-request](https://github.com/igrigorik/em-http-request), as well as [em-synchrony](https://github.com/igrigorik/em-synchrony).

## Setup project

### Install Docker
Install [Docker](https://docs.docker.com/install/) & [Docker Compose](https://docs.docker.com/compose/install/)

Then,

```
docker-compose build
```

## Run tests

```
docker-compose run --rm test
```

## Run the web server

```
docker-compose up web
```

## Run the development container

```
docker-compose run --rm dev
```
