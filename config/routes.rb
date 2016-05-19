WesterosAlliances::Engine.routes.draw do

  resources :game_board, only: []  do
    resource :bets, only: [ :show, :new, :create ] do
      get :logs
    end
  end

end
