class AddColumnIntoResorts < ActiveRecord::Migration
  def change
    add_column :resorts, :season_start, :date
    add_column :resorts, :season_end, :date

    Resort.update_all(season_start: '2016-01-01', season_end: '2016-12-31')
  end
end
