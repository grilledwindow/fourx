defmodule FTest do
  use ExUnit.Case
  doctest F

  setup_all do
    %{dimensions: {6, 7}, board: F.create_board(6, 7)}
  end

  test "should reach end", state do
    {ny, nx} = state[:dimensions]
    Enum.each([:vertical, :horizontal, :diagonal_right, :diagonal_left], fn direction ->
      {sy, sx} = {ny - 1, nx - 1}
      assert {:none, ^sy, ^sx} = F.find_adjacent(state[:board], 1, state[:dimensions], direction)
    end)
  end

  test "find vertical", state do
    board = %{state[:board] |
      0 => %{ 3 => 1 },
      1 => %{ 3 => 1 },
      2 => %{ 3 => 1 },
      3 => %{ 3 => 1 }
    }

    assert {:some, 0, 3} = F.find_adjacent(board, 1, state[:dimensions], :vertical)
  end

  test "shouldn't find vertical", state do
    board = %{state[:board] |
      0 => %{ 3 => 1 },
      1 => %{ 3 => 1 },
      2 => %{ 3 => 1 },
      4 => %{ 3 => 1 }
    }

    assert {:none, _, _} = F.find_adjacent(board, 1, state[:dimensions], :vertical)
  end

  test "find horizontal", state do
    board = %{state[:board] |
      0 => %{ 0 => 1, 1 => 1, 2 => 1, 3 => 1 },
    }

    assert {:some, 0, 0} = F.find_adjacent(board, 1, state[:dimensions], :horizontal)
  end

  test "shouldn't find horizontal", state do
    board = %{state[:board] |
      0 => %{ 0 => 1, 2 => 1, 3 => 1 },
      1 => %{ 0 => 1 }
    }

    assert {:none, _, _} = F.find_adjacent(board, 1, state[:dimensions], :horizontal)
  end

  test "find diagonal_right", state do
    board = %{state[:board] |
      0 => %{ 3 => 1 },
      1 => %{ 4 => 1 },
      2 => %{ 5 => 1 },
      3 => %{ 6 => 1 }
    }

    assert {:some, 0, 3} = F.find_adjacent(board, 1, state[:dimensions], :diagonal_right)
  end

  test "shouldn't find diagonal_right two rows apart", state do
    board = %{state[:board] |
      0 => %{ 4 => 1 },
      1 => %{ 5 => 1 },
      2 => %{ 6 => 1 },
      4 => %{ 0 => 1 }
    }

    assert {:none, _, _} = F.find_adjacent(board, 1, state[:dimensions], :diagonal_right)
  end

  test "find diagonal_left", state do
    board = %{state[:board] |
      3 => %{ 3 => 1 },
      4 => %{ 2 => 1 },
      5 => %{ 1 => 1 },
      6 => %{ 0 => 1 }
    }

    assert {:some, 3, 3} = F.find_adjacent(board, 1, state[:dimensions], :diagonal_left)
  end

  test "shouldn't find diagonal_left on same row", state do
    board = %{state[:board] |
      3 => %{ 2 => 1 },
      4 => %{ 1 => 1 },
      5 => %{ 0 => 1, 6 => 1 }
    }

    assert {:none, _, _} = F.find_adjacent(board, 1, state[:dimensions], :diagonal_right)
  end
end
