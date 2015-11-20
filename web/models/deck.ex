defmodule TexasHoldem.Deck do
  defmodule Card do
    defstruct [:rank, :suit]
  end

  def new do
    for rank <- ranks, suit <- suits do 
      %Card{rank: rank, suit: suit}
    end |> Enum.shuffle
  end

  def ranks, do: Enum.to_list(2..14)

  def suits, do: [:spades, :clubs, :hearts, :diamonds]
end
