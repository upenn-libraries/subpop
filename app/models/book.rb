class Book < ActiveRecord::Base
  include UserFields

  has_many :title_pages, dependent: :destroy, inverse_of: :book
  has_many :evidence, dependent: :destroy, inverse_of: :book
  has_many :context_images, dependent: :destroy, inverse_of: :book
  has_many :photos, dependent: :destroy, inverse_of: :book

  validates_presence_of :title
  accepts_nested_attributes_for :title_pages

  scope :for_user, -> (user) {
    where "created_by_id = ? or updated_by_id = ?",  user.id, user.id
  }

  def holder
    return repository if repository.present?
    owner
  end

  def photos_queued
    photos.queued.count
  end

  def photos_hidden
    photos.unqueued.count
  end

  def all_queued?
    photos_hidden == 0
  end

  def queued_photos
    photos.queued if photos.present?
  end

  def publishables
    title_pages.active + context_images.used + evidence.active
  end

  def full_call_number
    return '' unless call_number.present?

    parts = [ repository, call_number ].flat_map { |s|
      s.present? ? s : []
    }.join ' '
  end

  def full_name
    s = full_call_number
    return s if s.present?

    # If there is no call number, return the repository and title.
    [ repository, title ].flat_map { |s| s.present? ? s : [] }.join ': '
  end

  def volume_name
    return nil unless vol_number.present?
    return vol_number if vol_number =~ /v\.|vol/i
    "Vol. #{vol_number}"
  end

  def full_title
    [ title, vol_number ].flat_map { |s| s.present? ? s : [] }.join ', '
  end
  alias_method :name, :full_title

  def publication_info?
    [ creation_place, creation_date, publisher ].any? &:present?
  end

  def publication_info
    [ publisher, creation_place, creation_date ].flat_map { |s|
      s.present? ? s : []
    }.join ', '
  end

  def publishable?
    return false if processing?
    publishables.any? &:publishable?
  end

  def unpublishable?
    return false if processing?
    on_flickr?
  end

  def on_flickr?
    publishables.any? &:on_flickr?
  end

  def processing?
    publishables.any? &:processing?
  end

  def publish
    publishables.each { |item| item.publish }
  end

  def to_s
    full_call_number
  end

  searchable do
    text :title
    text :repository
    text :owner
    text :collection
    text :geo_location
    text :call_number
    text :catalog_url
    text :author
    text :creation_place
    string :title, stored: true
    string :repository, stored: true
    string :owner, stored: true
    string :collection, stored: true
    string :geo_location, stored: true
    string :call_number, stored: true
    string :catalog_url, stored: true
    string :author, stored: true
    string :creation_place, stored: true
  end
end
