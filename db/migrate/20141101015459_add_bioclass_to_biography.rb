class AddBioclassToBiography < ActiveRecord::Migration
  def change
    add_column :biographies, :biography_class, :integer
  end
end
