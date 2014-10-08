class CreateBiographies < ActiveRecord::Migration
  def change
    create_table :biographies do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.string :rough_gender, null: false, default: "unknown"
      t.string :verified_gender, null: false, default: "not verified"
      t.timestamps null: false
    end
  end
end
