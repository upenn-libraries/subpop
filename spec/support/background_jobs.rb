# See Thoughtbot's article on running background jobs inline for tests.
#  https://robots.thoughtbot.com/process-jobs-inline-when-running-acceptance-tests
module BackgroundJobs
  def run_background_jobs_immediately
    delay_jobs = Delayed::Worker.delay_jobs
    Delayed::Worker.delay_jobs = false
    yield
    Delayed::Worker.delay_jobs = delay_jobs
  end
end