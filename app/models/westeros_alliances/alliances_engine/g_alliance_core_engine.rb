module WesterosAlliances
  module AlliancesEngine
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
      # http://www.mitchcrowe.com/10-most-underused-activerecord-relation-methods
      def alliance_members( house )
        HHouse.joins( :al_alliances ).merge( al_alliances.where( h_peer_house_id: house.id ) )
      end

      # Check if a house is a minor alliance member
      # This is required, because a minor alliance member can't initiate an alliance or declare war
      def minor_alliance_member?( house )
        al_house = al_houses.find_by( h_house_id: house.id )
        al_house&.minor_alliance_member
      end

      # Set if an alliance master can initiate alliance negotiations (a player) or not (a NPC)
      def set_alliance_negotiation_rights( house, negotiation_rights )
        al_house = al_houses.where( h_house_id: house.id ).first_or_initialize
        al_house.minor_alliance_member = !negotiation_rights
        al_house.save!
      end

      # Create an alliance between two houses
      def
      create_alliance( house_a, house_b, last_bet )
        can_negotiate?( house_a, house_b )

        minor_allies = ( [ house_b ] + house_b.vassals ).uniq
        all_allies = ( [ house_a ] + house_a.vassals + alliance_members( house_a ) + minor_allies ).uniq

        ActiveRecord::Base.transaction do

          # master_house and all it's vassals are marked as a minor alliance member (thus cant't ever be a master member)
          # Minor are included for coherence
          minor_allies.each do |ally|
            al_house = al_houses.where( h_house_id: ally.id ).first_or_initialize
            al_house.last_bet = last_bet
            al_house.save!
          end

          # We need to delete the current alliances of the minor house and all vassals
          minor_allies_ids = minor_allies.map{ |a| a.id }
          al_alliances.where( h_house_id: minor_allies_ids ).delete_all
          al_alliances.where( h_peer_house_id: minor_allies_ids ).delete_all

          # We also need to remove their old enemies
          al_enemies.where( h_house_id: minor_allies_ids ).delete_all
          al_enemies.where( h_peer_house_id: minor_allies_ids).delete_all

          # Setup the alliances links
          all_allies.each do |ally_m|
            all_allies.each do |ally_p|
              next if ally_m == ally_p
              # puts "About to create alliance : #{ally_m}, #{ally_p}"
              # Check if the new allies were enemies, if yes, we remove them
              # enemies_test = al_enemies.where( h_house_id: ally_m.id, h_peer_house_id: ally_p.id ).first
              # enemies_test.delete if enemies_test
              al_alliances.where( h_house_id: ally_m.id, h_peer_house_id: ally_p.id ).first_or_create!
            end
          end

          # And create the news one
          minor_allies_ids.each do |minor_ally_id|
            enemies( house_a ).pluck( :id ).each do |house_a_enemy_id|
              al_enemies.where( h_house_id: minor_ally_id, h_peer_house_id: house_a_enemy_id ).first_or_create!
              al_enemies.where( h_house_id: house_a_enemy_id, h_peer_house_id: minor_ally_id ).first_or_create!
            end
          end
        end
      end
    end
  end
end
