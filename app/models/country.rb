require 'open-uri'

class Country < ActiveRecord::Base
  extend Sletat
  belongs_to :country_category
  has_many :depart_cities
  has_many :resorts

  has_attached_file :flag,
    styles: { thumb: "200x200", medium: "500x500>", big: "1000x1000>" }
  validates_attachment_content_type :flag, content_type: /\Aimage\/.*\Z/

  has_attached_file :header_img,
    styles: { thumb: "442x300#>", medium: "500x500>", big: "1000x1000>" }
  validates_attachment_content_type :header_img, content_type: /\Aimage\/.*\Z/

  def self.sync
    data = get_res_data('GetCountries')
    if data
      data.each do |country|
        Country.where(name: country['Name']).first_or_create do |c|
          c.sletat_id = country['Id']
          c.alias = country['Alias'] if country['Alias'] != 'NIL'
          c.display = true
        end
      end
    end
  end
end
