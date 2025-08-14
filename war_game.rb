def main
  values = {
    "1" => 1,
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "10" => 10,
    "J" => 11,
    "Q" => 12,
    "K" => 13,
    "A" => 14,
  }

  deck = [
    "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A",
    "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A",
    "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A",
    "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A",
  ]
  num_of_players = 0

  players = []

  while true
    puts "How many players?"
    num_of_players = gets

    num_of_players = num_of_players.chomp.to_i

    # check if num of players between 1 and 4
    break if num_of_players == 2 || num_of_players == 4

    puts "Invalid number of players"
  end

  puts "#{num_of_players} are going to play!"

  shuffled_deck = deck.shuffle

  if num_of_players == 2
    players.push(shuffled_deck[0..25])
    players.push(shuffled_deck[26..])
  elsif num_of_players == 4
    players.push(shuffled_deck[0..12])
    players.push(shuffled_deck[13..25])
    players.push(shuffled_deck[26..38])
    players.push(shuffled_deck[39..51])
  end

  game_done = false
  while !game_done
    # each round
    cards_played = []
    players.each.with_index(1) do |player, i|
      puts "player #{i}'s deck: #{player.join(' ')}"
      if player.empty?
        puts "Hey player #{i} you're out of cards!"
        next
      end

      # top card
      played = player.shift
      puts "player #{i} played #{played}"
      cards_played.push(played)
    end

    puts "cards played #{cards_played.join(" ")}"

    # find winner
    winner_val = cards_played.max { |a, b| values[a] <=> values[b] }

    puts "winning val is #{winner_val}"
    winners = cards_played.each_index.select{ |i| cards_played[i] == winner_val }

    # tie?!?!?!
    if winners.length > 1
      puts "#{winners.map{ |i| i + 1 }.join(" ")} are TIED"
      # top 3 of each tied player deck
      breaker = false
      total_tied_deck = []
      3.times do |i|
        # this needs to be a hash so can remember player
        # regular round deck was just doing it based on indicies
        tied_deck = {}
        winners.each do |winner|
          next if players[winner].length == 0
          tied_deck[winner] = players[winner].shift
        end

        puts "tied deck #{tied_deck.values.join(" ")}"
        tie_winner_val = tied_deck.values.max { |a, b| values[a] <=> values[b] }
        puts "tie winning val is #{tie_winner_val}"
        tie_winners = tied_deck.select { |key, val| val == tie_winner_val }.keys
        total_tied_deck.concat(tied_deck.values)
        if tie_winners.length == 1
          puts "the tie was broken!"
          winners =[tie_winners[0]]
          cards_played.concat(total_tied_deck)
          breaker = true
          break
        else
          winners = tie_winners
        end
      end

      if breaker == false
        puts "what to do now? tie breaker failed!"
        return
      end
    end

    # winner gets the cards
    players[winners[0]].concat(cards_played)
    puts "player #{winners[0]+ 1} wins this round!"

    # if any player has 52 cards than game over and that player is winner
    if (players.any? { |player| player.length == 52})
      winner = players.each_index.select{ |i| players[i].length == 52 }
      puts "player #{winner + 1} wins!"
      game_done = true
      break
    end

    puts "Enter for next round"
    gets
  end

end


main
