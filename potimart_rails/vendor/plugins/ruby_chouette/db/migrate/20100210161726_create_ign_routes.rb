class CreateIgnRoutes < ActiveRecord::Migration

  def self.column_exists?(table, column)
    column = column.to_s
    columns(table).any? { |c| c.name == column }
  end

  def self.up
    unless table_exists?("ign_routes")
      create_table :ign_routes, :primary_key => :gid do |t|
        t.integer :nb_voies, :pos_sol
        t.float :prec_plani, :prec_alti, :largeur, :z_ini, :z_fin
        t.string :id, :nature, :numero, :importance, :cl_admin, :gestion, :mise_serv, :it_vert, :it_europ, :fictif, :franchisst, :nom_iti, :sens, :typ_adres, :etat

        t.string :nom_rue_g, :nom_rue_d, :inseecom_g, :inseecom_d, :codevoie_g, :codevoie_d
        t.integer :bornedeb_g, :bornedeb_d, :bornefin_g, :bornefin_d
      end 
    end
  end

  def self.down
    # Don't drop "real" ign_routes table 
    unless column_exists?(:ign_routes, :the_geom)
      drop_table :ign_routes
    end
  end
end
