class FixDeparturesDispositionColumnName < ActiveRecord::Migration
  def change
    rename_column :departures, :application_id, :disposition_id
    rename_column :departures, :application_type, :disposition_type

    rename_index :departures, :index_departures_on_application, :index_departures_on_disposition
  end
end
