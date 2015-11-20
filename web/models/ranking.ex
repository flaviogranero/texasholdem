defmodule TexasHoldem.Ranking do

  def evaluate(cards) do
    cards |> Enum.map(&to_tuple/1) |> Enum.sort |> eval
  end

  defp to_tuple(
    %TexasHoldem.Deck.Card{rank: rank, suit: suit}
  ), do: {rank, suit}

  defp eval(
    [{10, s}, {11, s}, {12, s}, {13, s}, {14, s}]
  ), do: :royal_flush

  defp eval(
    [{a, s}, {_b, s}, {_c, s}, {_d, s}, {e, s}]
  ) when e - a == 4, do: :straight_flush
  defp eval(
    [{2, s}, {3, s}, {4, s}, {5, s}, {14, s}]
  ), do: :straight_flush

  defp eval(
    [{a, _}, {a, _}, {a, _}, {a, _}, {b, _}]
  ), do: :four_of_a_kind
  defp eval(
    [{b, _}, {a, _}, {a, _}, {a, _}, {a, _}]
  ), do: :four_of_a_kind
end
