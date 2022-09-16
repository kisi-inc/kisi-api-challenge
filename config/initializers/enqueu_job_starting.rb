Rails.application.config.after_initialize do
    #firstjobs will be queued in the firstjobs topic and perfomed inmediately
    #secondjobs will be queued in the secondjobs topic and perfomed async

    unless ENV['ONLY_PULL']
        Rails.application.load_tasks
        Rake::Task['loads:run'].invoke
    end
end