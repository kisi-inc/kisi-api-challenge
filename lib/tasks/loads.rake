namespace(:loads) do
    desc("Enqueue 5 jobs")
    task(run: :environment) do

    FirstJob.set(queue: :FirstJob, wait: 0.seconds).perform_later("Hello World")
    SecondJob.set(queue: :SecondJob, wait: 1.seconds).perform_later( "Bye World")
    SecondJob.set(queue: :SecondJob, wait: 2.seconds).perform_later( "Bye World")
    SecondJob.set(queue: :SecondJob, wait: 3.seconds).perform_later( "Bye World")
    FirstJob.set(queue: :FirstJob, wait: 0.seconds).perform_later("Hello World")

    end
end