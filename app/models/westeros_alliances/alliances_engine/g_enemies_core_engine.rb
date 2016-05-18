module WesterosAlliances
  module AlliancesEngine
    module GEnemiesCoreEngine

      # True if two houses are allied
      def enemies?( house_a, house_b )
        al_enemies.where( h_house_id: house_a.id, h_peer_house_id: house_b.id ).exists?
      end

      # Return all enemies of a house
      def enemies( house )
        HHouse.joins( :al_enemies ).merge( al_enemies.where( h_peer_house_id: house.id ) )
      end

      def set_enemies( house_a, house_b )

        can_negotiate?( house_a, house_b )

        # Allied houses can't declare war to themselves
        refute( self.class, __method__, allied?( house_a, house_b ), "Allies can't declare war to other allies" )

        ActiveRecord::Base.transaction do
          alliance_a_ids =  ( [ house_a.id ] + allies( house_a ).pluck( :id ) + house_a.vassals.pluck( :id ) )
          alliance_b_ids =  ( [ house_b.id ] + allies( house_b ).pluck( :id ) + house_b.vassals.pluck( :id ) )

          alliance_a_ids.each do |ally_a_id|
            alliance_b_ids.each do |ally_b_id|
              unless ally_a_id == ally_b_id
                al_alliances.where( h_house_id: ally_a_id, h_peer_house_id: ally_b_id ).delete_all
                al_alliances.where( h_house_id: ally_b_id, h_peer_house_id: ally_a_id ).delete_all
                al_enemies.where( h_house_id: ally_a_id, h_peer_house_id: ally_b_id ).first_or_create!
                al_enemies.where( h_house_id: ally_b_id, h_peer_house_id: ally_a_id ).first_or_create!
              end
            end
          end
        end
      end
    end
  end
end