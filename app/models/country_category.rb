class CountryCategory < ActiveRecord::Base
  has_many :countries
end
