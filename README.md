# The Kisi Backend Code Challenge

This repository can be used as a starting point for the Kisi Backend Code Challenge. Feel free to replace this `README.md` with your own when you submit your solution.

This repository contains:
- A bare-bones Rails 6 API app with a `Gemfile` that contains the neccessary libraries for the project.
- A rake task ([lib/tasks/worker.rake](lib/tasks/worker.rake)) that can be used to launch the worker process. Use as a starting point for your own code.
- A class ([lib/pubsub.rb](lib/pubsub.rb)) that wraps the GCP Pub/Sub client. Use as as a starting point for your own code.
- A [Dockerfile](Dockerfile) and a [docker-compose.yml](docker-compose.yml) configured to spin up necessary services (web server, worker, pub/sub emulator).

To start all services, make sure you have [Docker](https://www.docker.com/products/docker-desktop/) installed and run:
```
$ docker compose up
```

To restart the worker, i.e. after a code change:
```
$ docker compose restart worker
```
