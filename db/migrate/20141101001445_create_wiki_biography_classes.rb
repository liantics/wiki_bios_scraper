class CreateWikiBiographyClasses < ActiveRecord::Migration
  def change
    create_table :wiki_biography_classes do |t|
      t.text :class_type
      t.text :class_url
      t.timestamps :times
    end
  end
end
