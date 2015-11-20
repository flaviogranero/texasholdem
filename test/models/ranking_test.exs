defmodule TexasHoldem.RankingTest do
  use ExUnit.Case
  alias TexasHoldem.Ranking
  alias TexasHoldem.Deck

  test "ranks as royal_flush" do
    cards = Enum.map 10..14, &(%Deck.Card{rank: &1, suit: :spades})
    assert Ranking.evaluate(cards) == Ranking.royal_flush
  end

  test "ranks as straight_flush" do
    cards = Enum.map 9..13, &(%Deck.Card{rank: &1, suit: :spades})
    assert Ranking.evaluate(cards) == Ranking.straight_flush
  end

  test "ranks as straight_flush with ACE" do
    cards = Enum.map(2..5, &(%Deck.Card{rank: &1, suit: :spades})) ++ [%Deck.Card{rank: 14, suit: :spades}]

    assert Ranking.evaluate(cards) == Ranking.straight_flush
  end

  test "ranks as four_of_a_kind" do
    cards = Enum.map(Deck.suits, &(%Deck.Card{rank: 4, suit: &1})) ++ [%Deck.Card{rank: 6, suit: :hearts}]
    assert Ranking.evaluate(cards) == Ranking.four_of_a_kind
  end

  test "ranks as four_of_a_kind with lower different card" do
    cards = Enum.map(Deck.suits, &(%Deck.Card{rank: 4, suit: &1})) ++ [%Deck.Card{rank: 3, suit: :hearts}]
    assert Ranking.evaluate(cards) == Ranking.four_of_a_kind
  end

  test "ranks as full_house" do    
    cards_rank_4 = Deck.suits 
                    |> Enum.map(&(%Deck.Card{rank: 4, suit: &1}))
                    |> Enum.take_random(3)
    cards_rank_6 = Deck.suits 
                    |> Enum.map(&(%Deck.Card{rank: 6, suit: &1}))
                    |> Enum.take_random(2)
    assert Ranking.evaluate(cards_rank_4 ++ cards_rank_6) == Ranking.full_house
  end

  test "ranks as full_house with 2 lower first" do    
    cards_rank_4 = Deck.suits 
                    |> Enum.map(&(%Deck.Card{rank: 4, suit: &1}))
                    |> Enum.take_random(2)
    cards_rank_6 = Deck.suits 
                    |> Enum.map(&(%Deck.Card{rank: 6, suit: &1}))
                    |> Enum.take_random(3)
    assert Ranking.evaluate(cards_rank_4 ++ cards_rank_6) == Ranking.full_house
  end

  test "combinations 4 elements in groups of 3" do
    assert Ranking.combinations([1,2,3,4], 3) == [
      [4, 3, 2], [4, 3, 1], [4, 2, 1], [3, 2, 1]
    ]
  end

  test "best possible hand" do
    board = [
      %Deck.Card{rank: 14, suit: :spades},
      %Deck.Card{rank: 14, suit: :clubs},
      %Deck.Card{rank: 10, suit: :clubs},
      %Deck.Card{rank: 9, suit: :spades},
      %Deck.Card{rank: 8, suit: :clubs}
    ]
    hand = [
      %Deck.Card{rank: 14, suit: :hearts},
      %Deck.Card{rank: 14, suit: :diamonds},
    ]
    four_of_a_kind = Ranking.four_of_a_kind
    {four_of_a_kind, _} = Ranking.best_possible_hand(board, hand)
  end
end
