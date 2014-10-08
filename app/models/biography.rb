class Biography < ActiveRecord::Base

  validates :name, presence: true
  validates :url, presence: true
  validates :rough_gender, presence: true
  validates :verified_gender, presence: true

  def generate_entries(this_name, this_url)
    self.name = this_name
    self.url = this_url
    self.save
  end
end
