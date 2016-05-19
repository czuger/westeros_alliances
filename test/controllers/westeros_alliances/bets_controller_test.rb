require_relative '../../test_helper'

module WesterosAlliances
  class BetsControllerTest < ActionController::TestCase

    setup do
      @routes = Engine.routes
      @gb = FactoryGirl.create( :g_game_board )
      @house = FactoryGirl.create( :h_house )
    end

    test "should get show" do
      get :show, game_board_id: @gb.id
      assert_response :success
    end

    test "should get new" do
      get :new, game_board_id: @gb.id
      assert_response :success
    end

    test "should get create" do
      post :create, game_board_id: @gb.id, asking_house_id: @house.id, houses_bets: {}
      assert_redirected_to new_game_board_bets_path
    end

  end
end
