class CreateBiographyStatistics < ActiveRecord::Migration
  def change
    create_table :biography_statistics do |t|
      t.string :name, null: false
      t.float :value, null: false
      t.string :statistic_type, null: false
      t.timestamps null: false
    end
  end
end
