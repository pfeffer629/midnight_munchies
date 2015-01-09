class CreateUsers < ActiveRecord::Migration
  def change
  	create_table :users do |t|
  		t.float :longitude
  		t.float :latitude
  	end
  end
end
