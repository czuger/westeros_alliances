module GAllianceCoreEngine

  # True if two houses are allied
  def allied?( house_a, house_b )
    AlAlliance.where( g_game_board_player_id: id, h_house_id: house_a.id, h_peer_house_id: house_b.id ).exists?
  end

  # Synonym for alliance_members
  def allies( house )
    alliance_members( house )
  end

  # Return all the alliance members for a given house
  def alliance_members( house )
    AlAlliance.where( g_game_board_player_id: id, h_house_id: house.id ).map{ |e| e.h_peer_house }
  end

  # Check if a house is a minor alliance member
  def minor_alliance_member?( house )
    al_house = AlHouse.find_by( g_game_board_player_id: id, h_house_id: house.id )
    al_house&.minor_alliance_member
  end

  # Create an alliance between two houses
  def create_alliance( house_a, house_b, last_bet )
    [ house_a, house_b ].each do |h|
      raise "#{self.class}##{__method__} : #{h.inspect} not suzerain" if h.vassal?
    end

    raise "#{self.class}##{__method__} : #{house_a.inspect} minor alliance member" if minor_alliance_member?( house_a )

    minor_allies = ( [ house_b ] + house_b.vassals ).uniq
    all_allies = ( [ house_a ] + house_a.vassals + alliance_members( house_a ) + minor_allies ).uniq

    ActiveRecord::Base.transaction do

      # master_house and all it's vassals are marked as a minor alliance member (thus cant't ever be a master member)
      # Minor are included for coherence
      minor_allies.each do |ally|
        al_house = AlHouse.where( g_game_board_player_id: id, h_house_id: ally.id ).first_or_initialize
        al_house.minor_alliance_member = true
        al_house.last_bet = last_bet
        al_house.save!
      end

      # We need to delete the current alliances of the minor house and all vassals
      AlAlliance.where( g_game_board_player_id: id, h_house_id: minor_allies.map{ |a| a.id } ).delete_all

      all_allies.each do |ally_m|
        all_allies.each do |ally_p|
          next if ally_m == ally_p
          AlAlliance.where( g_game_board_player_id: id, h_house_id: ally_m.id, h_peer_house_id: ally_p.id ).first_or_create!
        end
      end
    end
  end

end