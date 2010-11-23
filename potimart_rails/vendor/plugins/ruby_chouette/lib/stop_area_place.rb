# coding: utf-8

class StopAreaPlace < ChouetteActiveRecord
  belongs_to :place
  belongs_to :stop_area
  
  validate_on_create :uniq_couples
  
  private
  def uniq_couples
    if StopAreaPlace.find_by_stop_area_id_and_place_id(self.stop_area_id, self.place_id)
      errors.add_to_base("Ce lien existe déjà !")
    end
  end
  
end
