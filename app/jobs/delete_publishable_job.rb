class DeletePublishableJob < ActiveJob::Base
  queue_as :default

  def perform publishable
    publishable.destroy
  end
end
