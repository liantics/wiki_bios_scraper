class WikiBiographyClass < ActiveRecord::Base
  validates :class_type, presence: true
  validates :class_url, presence: true

end
