module GAllianceCoreEngine

  # True if two houses are allied
  def allied?( house_a, house_b )
    al_alliances.where( h_house_id: house_a.id, h_peer_house_id: house_b.id ).exists?
  end

  # Synonym for alliance_members
  def allies( house )
    alliance_members( house )
  end

  # Return all the alliance members for a given house
  # TODO : try to use merge to avoid map http://www.mitchcrowe.com/10-most-underused-activerecord-relation-methods/
  def alliance_members( house )
    al_alliances.where( h_house_id: house.id ).map{ |e| e.h_peer_house }
  end

  # Check if a house is a minor alliance member
  # This is required, because a minor alliance member can't initiate an alliance or declare war
  def minor_alliance_member?( house )
    al_house = al_houses.find_by( h_house_id: house.id )
    al_house&.minor_alliance_member
  end

  # Create an alliance between two houses
  def create_alliance( house_a, house_b, last_bet )
    can_negotiate?( house_a, house_b )

    minor_allies = ( [ house_b ] + house_b.vassals ).uniq
    all_allies = ( [ house_a ] + house_a.vassals + alliance_members( house_a ) + minor_allies ).uniq

    ActiveRecord::Base.transaction do

      all_allies_ids = all_allies.map{ |e| e.id }
      new_allies_ids = ( [ house_b ] + house_b.vassals ).map( &:id ).uniq

      al_enemies.where( h_house_id: all_allies_ids, h_enemy_house_id: new_allies_ids ).delete_all
      al_enemies.where( h_house_id: new_allies_ids, h_enemy_house_id: all_allies_ids ).delete_all

      # TODO : setup new ennemies according to newly forged alliance
      # TODO ; merge ennemies and alliances in one table
      # Use a flag : ennemies : if true, then alliance is broken and they are ennemies, otherwise, they are allies
      # This will help alliance stealing, ennemies will just have to change a flag.
      # Also, will prohibit having enemies and allies

      # master_house and all it's vassals are marked as a minor alliance member (thus cant't ever be a master member)
      # Minor are included for coherence
      minor_allies.each do |ally|
        al_house = al_houses.where( h_house_id: ally.id ).first_or_initialize
        al_house.minor_alliance_member = true
        al_house.last_bet = last_bet
        al_house.save!
      end

      # We need to delete the current alliances of the minor house and all vassals
      al_alliances.where( h_house_id: minor_allies.map{ |a| a.id } ).delete_all

      all_allies.each do |ally_m|
        all_allies.each do |ally_p|
          next if ally_m == ally_p
          al_alliances.where( h_house_id: ally_m.id, h_peer_house_id: ally_p.id ).first_or_create!
        end
      end

    end
  end

end