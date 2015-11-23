defmodule TexasHoldem.Ranking do

  def royal_flush, do:     10
  def straight_flush, do:  9
  def four_of_a_kind, do:  8
  def full_house, do:      7
  def flush, do:           6
  def straight, do:        5
  def three_of_a_kind, do: 4
  def two_pair, do:        3
  def one_pair, do:        2
  def high_card, do:       1

  def best_possible_hand(board, hand) do
    board ++ hand
      |> combinations(5)
      |> Stream.map(&{evaluate(&1), &1})
      |> Enum.max
  end

  def evaluate(cards) do
    cards |> Enum.map(&to_tuple/1) |> Enum.sort |> eval
  end

  defp to_tuple(
    %TexasHoldem.Deck.Card{rank: rank, suit: suit}
  ), do: {rank, suit}

  defp eval(
    [{10, s}, {11, s}, {12, s}, {13, s}, {14, s}]
  ), do: royal_flush

  defp eval(
    [{a, s}, {_b, s}, {_c, s}, {_d, s}, {e, s}]
  ) when e - a == 4, do: straight_flush
  defp eval(
    [{2, s}, {3, s}, {4, s}, {5, s}, {14, s}]
  ), do: straight_flush

  defp eval(
    [{a, _}, {a, _}, {a, _}, {a, _}, {_b, _}]
  ), do: four_of_a_kind
  defp eval(
    [{_b, _}, {a, _}, {a, _}, {a, _}, {a, _}]
  ), do: four_of_a_kind

  defp eval(
    [{a, _}, {a, _}, {a, _}, {b, _}, {b, _}]
  ), do: full_house
  defp eval(
    [{b, _}, {b, _}, {a, _}, {a, _}, {a, _}]
  ), do: full_house

  defp eval([{_e, s}, {_d, s}, {_c, s}, {_b, s}, {_a, s}]), do: flush

  defp eval([{a, _}, {b, _}, {c, _}, {d, _}, {e, _}])
    when a + 1 == b and b + 1 == c and c + 1 == d and d + 1 == e,
    do: straight
  defp eval([{2, _}, {3 , _}, {4 , _}, {5 , _}, {14, _}]), do: straight

  defp eval([{a, _}, {a, _}, {a, _}, {_c, _}, {_b, _}]), do: three_of_a_kind
  defp eval([{_c, _}, {a, _}, {a, _}, {a, _}, {_b, _}]), do: three_of_a_kind
  defp eval([{_c, _}, {_b, _}, {a, _}, {a, _}, {a, _}]), do: three_of_a_kind

  defp eval([{b, _}, {b, _}, {a, _}, {a, _}, {_c, _}]), do: two_pair
  defp eval([{b, _}, {b, _}, {_c, _}, {a, _}, {a, _}]), do: two_pair
  defp eval([{_c, _}, {b, _}, {b, _}, {a, _}, {a, _}]), do: two_pair

  defp eval([{a, _}, {a, _}, {_d, _}, {_c, _}, {_b, _}]), do: one_pair
  defp eval([{_d, _}, {a, _}, {a, _}, {_c, _}, {_b, _}]), do: one_pair
  defp eval([{_d, _}, {_c, _}, {a, _}, {a, _}, {_b, _}]), do: one_pair
  defp eval([{_d, _}, {_c, _}, {_b, _}, {a, _}, {a, _}]), do: one_pair

  defp eval([{_e, _}, {_d, _}, {_c, _}, {_b, _}, {_a, _}]), do: high_card

  # Ported from the Erlang
  # http://rosettacode.org/wiki/Combinations#Dynamic_Programming
  def combinations(list, k), do: List.last(all_combinations(list, k))

  defp all_combinations(list, k) do
    accum = [[[]]] ++ List.duplicate([], k)
    Enum.reduce list, accum, fn(x, next) ->
      sub = Enum.take(next, length(next) - 1)
      step = [[]] ++ (for l <- sub, do: (for s <- l, do: [x|s]))
      :lists.zipwith(&:lists.append/2, step, next)
    end
  end
end
