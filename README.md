# Solution for The Kisi Backend Code Challenge

## ActiveJob with Google Cloud Pub/Sub Integration

## Author: William Eduardo Calderón Castillo

## Email: wecalderonc@unal.edu.co

## Introduction

This project demonstrates an integration of Rails ActiveJob with Google Cloud Pub/Sub. It includes a custom ActiveJob queue adapter for GCP Pub/Sub, a background job processing system, and a load testing script. The aim is to provide a robust solution for asynchronous job processing in a Rails application using Google Cloud Pub/Sub.

## Getting Started

### Setup

1. **Clone the Repository:**

   ```bash
   git clone [repository-url]
   cd [repository-name]
   ```

2. **Start Docker Containers:**

   In the project directory, run:

   ```bash
   docker-compose up
   ```

   This command builds the necessary Docker containers for the web server and worker.

3. **Run the Load Test (Optional):**

   In another terminal, execute:

   ```bash
   docker-compose exec web bin/rails runner -e development "require './lib/load_test'; LoadTest.run(60)"
   ```

   Replace `60` with the number of seconds you want the load test to run.
