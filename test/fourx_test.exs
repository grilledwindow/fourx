defmodule FourxTest do
  use ExUnit.Case
  doctest Fourx

  setup_all do
    %{nx: 7, board: Fourx.create_board(7, 6)}
  end

  def filter_player(board, player), do: Map.filter(board, fn {_k, v} -> v === player end)

  test "find vertical", state do
    board = %{state[:board] | 0 => 1, 7 => 1, 14 => 1, 21 => 1, 22 => 1}
      |> filter_player(1)

    result = Fourx.find_adjacent(board, state[:nx], :vertical)
    assert(result == {0, 4})
  end

  test "shouldn't find vertical", state do
    board = %{state[:board] | 0 => 1, 7 => 1, 14 => 1, 20 => 1, 28 => 1}
      |> filter_player(1)

    {_, consecutive} = Fourx.find_adjacent(board, state[:nx], :vertical)
    assert(consecutive < 4)
  end

  test "find horizontal", state do
    board = %{state[:board] | 3 => 1, 4 => 1, 5 => 1, 6 => 1, 7 => 1, 8 => 1}
      |> filter_player(1)

    result = Fourx.find_adjacent(board, state[:nx], :horizontal)
    assert(result == {3, 4})
  end

  test "shouldn't find horizontal", state do
    board = %{state[:board] | 3 => 1, 4 => 1, 5 => 1, 7 => 1, 8 => 1}
      |> filter_player(1)

    {_, consecutive} = Fourx.find_adjacent(board, state[:nx], :horizontal)
    assert(consecutive < 4)
  end

  test "find diagonal_right", state do
    board = %{state[:board] | 4 => 1, 7 => 1, 15 => 1, 23 => 1, 31 => 1}
      |> filter_player(1)

    result = Fourx.find_adjacent(board, state[:nx], :diagonal_right)
    assert(result == {7, 4})
  end

  test "shouldn't find diagonal_right two rows apart", state do
    board = %{state[:board] | 4 => 1, 12 => 1, 20 => 1, 28 => 1}
      |> filter_player(1)

    {_, consecutive} = Fourx.find_adjacent(board, state[:nx], :diagonal_left)
    assert(consecutive < 4)
  end

  test "find diagonal_left", state do
    board = %{state[:board] | 4 => 1, 13 => 1, 19 => 1, 25 => 1, 31 => 1}
      |> filter_player(1)

    result = Fourx.find_adjacent(board, state[:nx], :diagonal_left)
    assert(result == {13, 4})
  end

  test "shouldn't find diagonal_left on same row", state do
    board = %{state[:board] | 0 => 1, 6 => 1, 12 => 1, 18 => 1}
      |> filter_player(1)

    {_, consecutive} = Fourx.find_adjacent(board, state[:nx], :diagonal_left)
    assert(consecutive < 4)
  end
end
