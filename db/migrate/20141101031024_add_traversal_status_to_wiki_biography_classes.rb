class AddTraversalStatusToWikiBiographyClasses < ActiveRecord::Migration
  def change
    add_column :wiki_biography_classes, :traversal_status, :boolean
  end
end
