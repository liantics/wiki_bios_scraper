class Biography < ActiveRecord::Base

  validates :name, presence: true
  validates :url, presence: true
  validates :rough_gender, presence: true
  validates :verified_gender, presence: true

  def generate_entries(this_name, this_url, biography_class)
    self.name = this_name
    self.url = this_url
    self.biography_class = biography_class
    self.save
  end
end
