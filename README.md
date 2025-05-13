# The Kisi Backend Code Challenge

This repository can be used as a starting point for the Kisi Backend Code Challenge. Feel free to replace this `README.md` with your own when you submit your solution.

This repository contains:
- A bare-bones Rails 8 API app with a `Gemfile` that contains the neccessary libraries for the project.
- A configured adapter ([lib/active_job/queue_adapters/pubsub_adapter.rb](lib/active_job/queue_adapters/pubsub_adapter.rb)) to enqueue jobs. Use as a starting point for your own code.
- A rake task ([lib/tasks/worker.rake](lib/tasks/worker.rake)) to launch the worker process. Use as a starting point for your own code.
- A class ([lib/pubsub.rb](lib/pubsub.rb)) that wraps the GCP Pub/Sub client. Use as as a starting point for your own code.
- A [Dockerfile](Dockerfile) and a [docker-compose.yml](docker-compose.yml) configured to spin up necessary services (web server, worker, pub/sub emulator).

The reason we provide a Docker-setup is so that you *don't* have to set up a *real* GCP project, and can instead use the emulator. If you prefer *not* to use Docker, you can ignore the following text.

To start all services, make sure you have [Docker](https://www.docker.com/products/docker-desktop/) installed and run:
```
$ docker compose up
```

If you prefer to start each service individually, run:
```
$ docker compose up web
$ docker compose up worker
$ docker compose up pubsub
```

To rebuild an image, run:
```
$ docker compose build web
```

To restart the worker, i.e. after a code change:
```
$ docker compose restart worker
```

To start a console:
```
$ docker compose run --rm worker bin/rails console
```

If you want to debug using `pry` and breakpoints, you might want to start a service manually instead:
```
$ docker compose run --rm worker bash
# bin/rails worker:run
```

If you run docker with a VM (e.g. Docker Desktop for Mac) we recommend you allocate at least 2GB Memory
