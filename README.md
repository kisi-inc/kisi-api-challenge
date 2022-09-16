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

The code will generate random 5 jobs to publish message in different queues in PubSub. This will be done at initializing or with a task that can be trigger from terminal.
To pull the messages from PubSub Console, there is a worker who also execute the job in question.
Finally, to enqueue 5 more jobs, there is a "Loads" task that can be executed by terminal.


Regarding the Semantic question: I think this code is "at-least-once" because for each job delivered it handed to the mechanism potentially multiple attempts, such that at least one succeeds or sended to a morge queue.


Finally, sadly I encounter some problems with docker and the credentials to connect with the console. The situation is that it can connect to the project in PubSub Console but does not list the topics.

For this reason, I am summiting the answer with 2 options:
1.- Run the code locally on your machine
2.- Run the code with docker composer (one time the credential issue is solve).


## How to run the code locally:

To run the code locally in you machine, please, clone this repo, change to python 3.9.0 and install gcrp with brew as:
```
$ brew install grpc  

```

At initializing the application will create and enqueue 5 random Jobs.
```
$ rails s
```

To pull and exceute the messages published by the above executed jobs, you can run the worker:

```
$ NOSOCK=true rake worker:run

```

To create 5 other random messages to be publish into Pubsub console

```
$ rake loads:run
```

## How to run the code with docker:


At initializing the application will create and enqueue 5 random Jobs.
```
$ docker compose up
```

To pull and exceute the messages published by the above executed jobs, you can run the worker:

```
$ docker-compose run web rake worker:run ONLY_PULL=true

```

To create 5 other random messages to be publish into Pubsub console

```
$ docker-compose run web rake loads:run
```


