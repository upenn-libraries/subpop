class ContentType < ActiveRecord::Base

  validates :name, uniqueness: true

  def <=> other
    self.sort_name <=> other.sort_name
  end

  def sort_name
    self.name.sub /^\W+/, ''
  end
end
