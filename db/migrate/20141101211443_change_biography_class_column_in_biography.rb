class ChangeBiographyClassColumnInBiography < ActiveRecord::Migration
  def change
    change_column :biographies, :biography_class, :string
  end
end
