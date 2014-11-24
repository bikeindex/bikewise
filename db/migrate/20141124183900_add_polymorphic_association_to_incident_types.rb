class AddPolymorphicAssociationToIncidentTypes < ActiveRecord::Migration
  def up
    change_table :incident_types do |t|
      t.references :type_property, :polymorphic => true
    end
  end
  def down
    change_table :incident_types do |t|
      t.remove_references :type_property, :polymorphic => true
    end
  end
end
