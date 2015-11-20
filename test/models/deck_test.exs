defmodule TexasHoldem.DeckTest do
  use ExUnit.Case
  alias TexasHoldem.Deck

  @ranks [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
  @suits [:spades, :clubs, :hearts, :diamonds]

  test "generate ranks" do
    assert Deck.ranks == @ranks
  end

  test "generate suits" do
    assert Deck.suits == @suits
  end

  test "card struct" do
    card = %Deck.Card{rank: 2, suit: :diamonds}
    %Deck.Card{rank: rank, suit: suit} = card
    assert rank == 2
    assert suit == :diamonds
  end

  test "new deck has unique cards" do
    deck = Deck.new
    assert Enum.count(deck) == 52
    assert deck 
           |> Enum.uniq_by(fn(%Deck.Card{rank: rank, suit: suit}) ->
                {rank, suit}
              end)
           |> Enum.count == 52
  end

  test "new deck includes all ranks" do
    deck = Deck.new
    assert deck 
           |> Enum.map(fn(%Deck.Card{rank: rank}) -> rank end)
           |> Enum.uniq
           |> Enum.sort == @ranks
  end

  test "new deck includes all suits" do
    deck = Deck.new
    assert deck 
           |> Enum.map(fn(%Deck.Card{suit: suit}) -> suit end)
           |> Enum.uniq
           |> Enum.sort == Enum.sort(@suits)
  end
end
