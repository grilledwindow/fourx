defmodule F do
  @type board_piece :: nil | 0 | 1

  def play() do
    {ny, nx} = {6, 7}
    create_board(ny, nx)
    |> print_board(ny, nx)
    |> play(1, {ny, nx})
  end

  def play(board, player, {ny, nx}) do
    {_, _, consecutive} = find_adjacent(board, player, {ny, nx}, :all)
    if consecutive === 4 do
      IO.puts("Player #{player + 1} won!")
    else
      with {x, _} <- IO.gets("Slot in column (1-7): ")
        |> String.trim("\n")
        |> Integer.parse
      do
        board 
        |> update_board(1 - player, ny, x - 1)
        |> print_board(ny, nx)
        |> play(1 - player, {ny, nx})
      end
    end
  end

  def find_adjacent(board, player, {ny, nx}, :all) do
    with {_, _, consecutive} when consecutive < 4 <- find_adjacent(board, player, {ny, nx}, :vertical),
      {_, _, consecutive} when consecutive < 4 <- find_adjacent(board, player, {ny, nx}, :horizontal),
      {_, _, consecutive} when consecutive < 4 <- find_adjacent(board, player, {ny, nx}, :diagonal_left)
    do
      find_adjacent(board, player, {ny, nx}, :diagonal_right)
    end
  end

  def find_adjacent(board, player, {ny, nx}, direction) do
    {dy, dx} = case direction do
      :vertical -> {1, 0}
      :horizontal -> {0, 1}
      :diagonal_right -> {1, 1}
      :diagonal_left -> {1, -1}
    end

    find_adjacent({board, player, ny, nx, dy, dx}, {0, 0}, 0)
  end
      
  # (sy,sx) is used so that the function can restart from the last incomplete pattern
  def find_adjacent(game={board, player, ny, nx, dy, dx}, {sy, sx}, consecutive) do
    {ty, tx} = {sy + dy * consecutive, sx + dx * consecutive}
    cond do
      (sy == ny - 1 and sx == nx - 1) or consecutive === 4 -> {sy, sx, consecutive}
      sx == nx -> find_adjacent(game, {sy + 1, 0}, 0)
      board[ty][tx] == player -> find_adjacent(game, {sy, sx}, consecutive + 1)
      true -> find_adjacent(game, {sy, sx + 1}, 0)
    end
  end

  def create_board(ny, nx) do
    col = Map.new(0..ny-1, &{&1, nil})
    Map.new(0..nx-1, &{&1, col})
  end

  def print_board(board, ny, nx) do
    Enum.reduce(ny-1..0, "", fn y, acc_row ->
      acc_row
        <> Enum.reduce(0..nx-1, "", fn x, acc_col ->
          piece = board[y][x]
          acc_col <> case piece do nil -> " -"; _ -> " #{piece + 1}" end
        end)
        <> "\n"
    end)
    <> Enum.reduce(0..ny, "\n", fn x, col_label -> col_label <> " #{x + 1}" end)
    |> IO.puts

    board
  end

  # TODO: check if column is full
  def update_board(board, player, ny, x) do
    Enum.reduce_while(0..ny-1, board, fn y, acc ->
      case acc[y][x] do
        nil -> {:halt, put_in(acc, [y, x], player)}
        _ -> {:cont, acc}
      end
    end)
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

