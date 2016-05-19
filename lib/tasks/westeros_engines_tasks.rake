namespace :westeros_alliances do

  desc 'Setup basic datas for manual tests'
  task :set_base_datas => :environment do
    HHouse.destroy_all
    GGameBoard.destroy_all

    @stark = HHouse.create_house_and_vassals( :stark, :karstark, :bolton, :corbois ).first
    @greyjoy = HHouse.create_house_and_vassals( :greyjoy, :botley, :harloi, :salfalaises ).first
    @lannister = HHouse.create_house_and_vassals( :lannister, :brax, :marpheux, :farman ).first
    @tyrell = HHouse.create_house_and_vassals( :tyrell, :chester, :grimm, :rowan ).first

    gb = GGameBoard.create!
    gb.set_alliance_negotiation_rights( @stark, true )
    gb.set_alliance_negotiation_rights( @lannister, true )
    gb.set_alliance_negotiation_rights( @greyjoy, false )
    gb.set_alliance_negotiation_rights( @tyrell, false)


  end

  desc "Advance turn on game board and compute alliances on all game boards"
  task :next_turn => :environment do
    GGameBoard.all.each do |gb|
      ActiveRecord::Base.transaction do
        gb.increment( :turn )
        gb.resolve_bets
      end
    end
  end

end
