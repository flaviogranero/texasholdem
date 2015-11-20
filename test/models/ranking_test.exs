defmodule TexasHoldem.RankingTest do
  use ExUnit.Case
  alias TexasHoldem.Ranking
  alias TexasHoldem.Deck

  test "ranks as royal_flush" do
    cards = Enum.map 10..14, &(%Deck.Card{rank: &1, suit: :spades})
    assert Ranking.evaluate(cards) == :royal_flush
  end

  test "ranks as straight_flush" do
    cards = Enum.map 9..13, &(%Deck.Card{rank: &1, suit: :spades})
    assert Ranking.evaluate(cards) == :straight_flush
  end

  test "ranks as straight_flush with ACE" do
    cards = Enum.map(2..5, &(%Deck.Card{rank: &1, suit: :spades})) ++ [%Deck.Card{rank: 14, suit: :spades}]

    assert Ranking.evaluate(cards) == :straight_flush
  end

  test "ranks as four_of_a_kind" do
    cards = Enum.map(Deck.suits, &(%Deck.Card{rank: 4, suit: &1})) ++ [%Deck.Card{rank: 6, suit: :hearts}]
    assert Ranking.evaluate(cards) == :four_of_a_kind
  end

  test "ranks as four_of_a_kind with lower different card" do
    cards = Enum.map(Deck.suits, &(%Deck.Card{rank: 4, suit: &1})) ++ [%Deck.Card{rank: 3, suit: :hearts}]
    assert Ranking.evaluate(cards) == :four_of_a_kind
  end

  test "ranks as full_house" do    
    cards_rank_4 = Deck.suits 
                    |> Enum.map(&(%Deck.Card{rank: 4, suit: &1}))
                    |> Enum.take_random(3)
    cards_rank_6 = Deck.suits 
                    |> Enum.map(&(%Deck.Card{rank: 6, suit: &1}))
                    |> Enum.take_random(2)
    assert Ranking.evaluate(cards_rank_4 ++ cards_rank_6) == :full_house
  end

  test "ranks as full_house with 2 lower first" do    
    cards_rank_4 = Deck.suits 
                    |> Enum.map(&(%Deck.Card{rank: 4, suit: &1}))
                    |> Enum.take_random(2)
    cards_rank_6 = Deck.suits 
                    |> Enum.map(&(%Deck.Card{rank: 6, suit: &1}))
                    |> Enum.take_random(3)
    assert Ranking.evaluate(cards_rank_4 ++ cards_rank_6) == :full_house
  end
end
