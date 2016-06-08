class Resort < ActiveRecord::Base
  belongs_to :country
  has_many :hotels, dependent: :destroy

  has_one :photo, class_name: 'Image', as: :imageable
  accepts_nested_attributes_for :photo, allow_destroy: true

  has_and_belongs_to_many :beaches

  def beach_names
    return if beaches.blank?

    beaches.map(&:name).join(', ')
  end

  def season_names
    m = {
      '01' => 'январь',
      '02' => 'февраль',
      '03' => 'март',
      '04' => 'апрель',
      '05' => 'май',
      '06' => 'июнь',
      '07' => 'июль',
      '08' => 'август',
      '09' => 'сентябрь',
      '10' => 'октябрь',
      '11' => 'ноябрь',
      '12' => 'декабрь'
    }

    season = String.new

    if season_start.present?
      month = season_start.strftime('%m')

      season += m[month]
    end

    if season_end.present?
      month = season_end.strftime('%m')

      season += " - #{m[month]}"
    end

    season
  end

  rails_admin do
    edit do
      include_all_fields

      configure :season_start, :date do
        date_format :default
      end

      configure :season_end, :date do
        date_format :default
      end
    end
  end
end
