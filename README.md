# Dashboard API

**API Gateway collecting all the publicly available services.**


## Prerequisites

- latest [Docker](https://www.docker.com/) (1.13.0 at the moment)
- latest [Docker Compose](https://docs.docker.com/compose/) (1.10.0 at the moment)
- curl
- make


## Quick start

Running the following commands should set up the environment with an `admin` user (with password `admin`).
The API should be available at `http://localhost:8000`.

To make sure there are no colliding ports, you should stop all other Docker containers
(or configure the mapped ports in `docker-compose.override.yml`)

``` bash
$ cp docker-compose.override.yml.example docker-compose.override.yml
$ make setup start
$ curl -i -X POST localhost:8000 -H "Host: service.model.user" -H "Content-Type: application/json" -d '{"username": "admin", "password": "admin"}'
```

**Note:** Depending on which images are already available locally (and on your download speed),
this could take some time from a few minutes to a standard coffee break.


## Installation

Create a `docker-composer.override.yml` file based on the example to expose the necessary ports.

Then run the following commands:

``` bash
$ make setup
$ make start
```

The `setup` target will:

- Build some images
- Start the database
- Run migrations
- Provision the gateway


## Usage

### Gateway

The gateway is responsible for publishing the specific Microservice endpoints.
Some internal services are (of course) not published, but in order to make development easier,
these are available under the service's host `service.[type].[name]`.

Example:

``` bash
$ curl -i localhost:8000/admin -H "Host: service.model.user"
```

In order to use to "production" setup of the dashboard locally the port *52481* is automatically configured for the gateway.
This is also configured in the frontend which will connect to your localhost on this port to communicate with the API.

To add new endpoints to an already running Gateway run the following command:

``` bash
$ make gateway
```

To apply changes to existing endpoints you have to manually delete that endpoint (for now).
It can easily be done with [KongDash](https://ajaysreedhar.github.io/kongdash/).


### Add a new user

Adding a new user is as simple as an HTTP call:

``` bash
$ curl -i -X POST localhost:52481 -H "Host: service.model.user" -H "Content-Type: application/json" -d '{"username": "admin", "password": "admin"}'
```


### Clean up the mess

Sometimes you might want to start over. Here is how you can:

``` bash
$ make clean
```

The `FORCE` option works here as well to immediately kill all the running containers.


## License

The MIT License (MIT). Please see [License File](LICENSE) for more information.
