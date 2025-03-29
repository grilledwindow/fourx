defmodule F do
  @type board_piece :: nil | 0 | 1

  def board do
    player = 1
    {ny, nx} = {6, 7}
    board = create_board(nx, ny)
      |> add_winning_positions
    
    find_adjacent(board, player, {ny, nx}, :vertical)

    print_board(board, nx, ny)
  end

  def find_adjacent(board, player, {ny, nx}, direction) do
    {dy, dx} = case direction do
      :vertical -> {1, 0}
      :horizontal -> {0, 1}
      :diagonal_right -> {1, 1}
      :diagonal_left -> {1, -1}
    end

    find_adjacent({board, player, ny, nx, dy, dx}, {0, 0}, 1)
  end
      
  # (sy,sx) is used so that the function can restart from the last incomplete pattern
  def find_adjacent(game={board, player, ny, nx, dy, dx}, {sy, sx}, consecutive) do
    {ty, tx} = {sy + dy * consecutive, sx + dx * consecutive}
    cond do
      (ty >= ny and tx >= nx) or consecutive === 4 -> {sy, sx, consecutive}
      tx >= nx -> find_adjacent(game, {sy + 1, 0}, 1)
      board[ty][tx] == player -> find_adjacent(game, {sy, sx}, consecutive + 1)
      true -> find_adjacent(game, {sy, sx + 1}, 1)
    end
  end

  def create_board(nx, ny) do
    col = Map.new(0..ny-1, &{&1, nil})
    Map.new(0..nx-1, &{&1, col})
  end

  def print_board(board, nx, ny) do
    Enum.reduce(ny-1..0, "", fn y, acc_row ->
      acc_row
        <> Enum.reduce(0..nx-1, "", fn x, acc_col ->
          piece = board[y][x]
          acc_col <> case piece do nil -> " -"; _ -> " #{piece}" end
        end)
        <> "\n"
    end)
    |> IO.puts
  end

  def add_winning_positions(map) do
    %{ map |
      0 => %{ 0 => 0, 1 => 1, 2 => 0, 3 => 1, 4 => 0, 5 => 1, 6 => 0 },
      1 => %{ 1 => 1, 2 => 0, 3 => 1, 4 => 0 },
      2 => %{ 2 => 0, 3 => 1, 4 => 0 },
      3 => %{ 3 => 1 }
    }
  end
end

