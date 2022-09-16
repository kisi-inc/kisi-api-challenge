# The Kisi Backend Code Challenge

This repository can be used as a starting point for the Kisi Backend Code Challenge. Feel free to replace this `README.md` with your own when you submit your solution.

This repository contains:
- A bare-bones Rails 6 API app with a `Gemfile` that contains the neccessary libraries for the project.
- A configured adapter ([lib/active_job/queue_adapters/pubsub_adapter.rb](lib/active_job/queue_adapters/pubsub_adapter.rb)) to enqueue jobs. Use as a starting point for your own code.
- A rake task ([lib/tasks/worker.rake](lib/tasks/worker.rake)) to launch the worker process. Use as a starting point for your own code.
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

To start a console:
```
$ docker compose run --rm web bin/rails console
```

If you run docker with a VM (e.g. Docker Desktop for Mac) we recommend you allocate at least 2GB Memory

# Answer Catalina Rojas

At initializing the application will create and enqueu 5 random Jobs .

To pull and exceute the messages published by the above executed jobs, you can run the worker

```
$ NOSOCK=true rake worker:run

```

To create 5 other random messages to be publish into Pubsub console

```
$ rake loads:run
```

I am having some problems with docker and the credentials . It can connect to the cloud and the project but does not liste the topics.
To run the code locally in you machine, please, clone this repo, change to python 3.9.0 and install gcrp with brew as:
```
$ brew install grpc  

```

