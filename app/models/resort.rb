class Resort < ActiveRecord::Base
  belongs_to :country
  has_many :hotels, dependent: :destroy

  has_one :photo, class_name: 'Image', as: :imageable
  accepts_nested_attributes_for :photo, allow_destroy: true
end
