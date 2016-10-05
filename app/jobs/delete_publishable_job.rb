class DeletePublishableJob < ActiveJob::Base
  queue_as :default

  def perform publishable, user
    publishable.delete_from_flickr user
    photo = publishable.photo
    publishable.destroy

    photo.destroy if photo.present? && photo.orphaned?
  end
end
