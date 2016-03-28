class UpdateFlickrJob < ActiveJob::Base
  queue_as :default

  before_perform do |job|
    job.arguments.first.update_columns publishing_to_flickr: true
  end

  after_perform do |job|
    job.arguments.first.update_columns publishing_to_flickr: false
  end

  def perform publishable
    publishable.republish!
  end
end
