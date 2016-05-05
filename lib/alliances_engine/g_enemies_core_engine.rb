module GEnemiesCoreEngine

  # True if two houses are allied
  def enemies?( house_a, house_b )
    al_enemies.where( h_house_id: house_a.id, h_enemy_house_id: house_b.id ).exists?
  end

  def set_enemies( house_a, house_b )
    ActiveRecord::Base.transaction do
      al_enemies.where( h_house_id: house_a.id, h_enemy_house_id: house_b.id ).first_or_create
      al_enemies.where( h_house_id: house_b.id, h_enemy_house_id: house_a.id ).first_or_create

      old_allies_ids = ( allies( house_a ) + allies( house_b ) + [ house_a, house_b ] ).uniq.map( &:id )
      al_houses.where( h_house_id: old_allies_ids ).delete_all
      al_alliances.where( h_house_id: old_allies_ids ).delete_all
      al_alliances.where( h_peer_house: old_allies_ids ).delete_all
    end
  end

end