[![Code Climate](https://codeclimate.com/github/czuger/feodalis/badges/gpa.svg)](https://codeclimate.com/github/czuger/feodalis)
[![Test Coverage](https://codeclimate.com/github/czuger/feodalis/badges/coverage.svg)](https://codeclimate.com/github/czuger/feodalis/coverage)

# Westeros Alliances

This dev is designed to be included in a bigger project. It's an old project about game of thrones I have to finalize.

## Usage

```ruby

# Create a game board player
@gbp = GGameBoardPlayer.create!
    
# Create a house and all it's vassals (master house is the first)
HHouse.create_house_and_vassals( :stark, :karstark )

# Create an alliance between two houses
@gbp.create_alliance( @stark, @greyjoy, 1 )

# Declare two houses ennemies
@gbp.set_enemies( @stark, @lannister )

# Check if two houses are allied
@gbp.allied?( @pyk, @tarly )

# Check if two houses are enemies
@gbp.enemies?( @pyk, @tarly )

# Set a bet on an alliance
@gbp.set_bet( @stark, @lannister, 10 )

# Resolve all the bets (best bet win)
@gbp.resolve_bets

# Retrieve a hash containing all ennemies, allies or neutrals for a house
@gbp.alliances_hash( @stark )

̀̀̀ ``
