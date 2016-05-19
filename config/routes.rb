WesterosAlliances::Engine.routes.draw do

  resources :game_board, only: []  do
    resource :bets, only: [ :show, :new, :create ]
  end

end
