defmodule FTest do
  use ExUnit.Case
  doctest F

  setup_all do
    %{dimensions: {6, 7}, board: F.create_board(6, 7)}
  end

  test "should reach end", state do
    {ny, nx} = state[:dimensions]
    Enum.each([:vertical, :horizontal, :diagonal_right, :diagonal_left], fn direction ->
      IO.puts(direction)
      {sy, sx, _} = F.find_adjacent(state[:board], 1, state[:dimensions], direction)
      assert({sy, sx} == {ny - 1, nx - 1})
    end)
  end

  test "find vertical", state do
    board = %{state[:board] |
      0 => %{ 3 => 1 },
      1 => %{ 3 => 1 },
      2 => %{ 3 => 1 },
      3 => %{ 3 => 1 }
    }

    result = F.find_adjacent(board, 1, state[:dimensions], :vertical)
    assert(result == {0, 3, 4})
  end

  test "shouldn't find vertical", state do
    board = %{state[:board] |
      0 => %{ 3 => 1 },
      1 => %{ 3 => 1 },
      2 => %{ 3 => 1 },
      4 => %{ 3 => 1 }
    }

    {_, _, consecutive} = F.find_adjacent(board, 1, state[:dimensions], :vertical)
    assert(consecutive < 4)
  end

  test "find horizontal", state do
    board = %{state[:board] |
      0 => %{ 0 => 1, 1 => 1, 2 => 1, 3 => 1 },
    }

    result = F.find_adjacent(board, 1, state[:dimensions], :horizontal)
    assert(result == {0, 0, 4})
  end

  test "shouldn't find horizontal", state do
    board = %{state[:board] |
      0 => %{ 0 => 1, 2 => 1, 3 => 1 },
      1 => %{ 0 => 1 }
    }

    {_, _, consecutive} = F.find_adjacent(board, 1, state[:dimensions], :horizontal)
    assert(consecutive < 4)
  end

  test "find diagonal_right", state do
    board = %{state[:board] |
      0 => %{ 3 => 1 },
      1 => %{ 4 => 1 },
      2 => %{ 5 => 1 },
      3 => %{ 6 => 1 }
    }

    result = F.find_adjacent(board, 1, state[:dimensions], :diagonal_right)
    assert(result == {0, 3, 4})
  end

  test "shouldn't find diagonal_right two rows apart", state do
    board = %{state[:board] |
      0 => %{ 4 => 1 },
      1 => %{ 5 => 1 },
      2 => %{ 6 => 1 },
      4 => %{ 0 => 1 }
    }

    {_, _, consecutive} = F.find_adjacent(board, 1, state[:dimensions], :diagonal_right)
    assert(consecutive < 4)
  end

  test "find diagonal_left", state do
    board = %{state[:board] |
      3 => %{ 3 => 1 },
      4 => %{ 2 => 1 },
      5 => %{ 1 => 1 },
      6 => %{ 0 => 1 }
    }

    result = F.find_adjacent(board, 1, state[:dimensions], :diagonal_left)
    assert(result == {3, 3, 4})
  end

  test "shouldn't find diagonal_left on same row", state do
    board = %{state[:board] |
      3 => %{ 2 => 1 },
      4 => %{ 1 => 1 },
      5 => %{ 0 => 1, 6 => 1 }
    }

    {_, _, consecutive} = F.find_adjacent(board, 1, state[:dimensions], :diagonal_right)
    assert(consecutive < 4)
  end
end
