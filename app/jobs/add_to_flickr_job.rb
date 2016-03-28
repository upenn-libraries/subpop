class AddToFlickrJob < ActiveJob::Base
  queue_as :default

  before_perform do |job|
    job.arguments.first.mark_in_process
  end

  after_perform do |job|
    job.arguments.first.unmark_in_process
  end

  def perform publishable
    publishable.publish_new!
  end
end
