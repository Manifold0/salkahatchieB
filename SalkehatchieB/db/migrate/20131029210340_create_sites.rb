class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :homeowner


      t.timestamps
    end
  end
end
