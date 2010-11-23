class CreateInseeIris < ActiveRecord::Migration
  def self.up
    create_table :insee_iris, :primary_key => :ogc_fid do |t|
      t.integer :ogc_fid
      t.polygon :the_geom, :srid => 4326
      t.string :code_iris
      t.string :nom_iris
      t.string :typ_iris
      t.string :code_insee
      t.string :nom_com
      t.integer :psdc
      t.integer :menages
      t.integer :nblog
      t.string :code_depart
      t.string :code_reg
      t.timestamps

    end
  end

  def self.down
    drop_table :insee_iris
  end
end
