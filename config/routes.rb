WesterosAlliances::Engine.routes.draw do

  resources :game_board, only: []  do
    resources :bets, only: [ :new, :create ]
    resource :alliances, only: [ :show ] do
      get :log
    end
  end

end
