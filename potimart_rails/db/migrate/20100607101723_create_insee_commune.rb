class CreateInseeCommune < ActiveRecord::Migration
  def self.up
    create_table :insee_communes, :primary_key => :ogc_fid do |t|
      t.integer :ogc_fid
      t.polygon :the_geom, :srid => 4326
      t.integer :id
      t.integer :feattyp
      t.string :order00
      t.string :order01
      t.string :order02
      t.string :order03
      t.string :order04
      t.string :order05
      t.string :order06
      t.string :order07
      t.integer :featarea
      t.integer :featperim
      t.string :name
      t.string :namelc
      t.timestamps
    end
  end

  def self.down
    drop_table :insee_communes
  end
end
