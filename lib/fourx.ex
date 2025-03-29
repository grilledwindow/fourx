defmodule Fourx do
  @type board_piece :: nil | 0 | 1

  def board do
    player = 1
    {nx, ny} = {7, 6}
    map = create_board(nx, ny)
      |> add_winning_positions
    
    Map.filter(map, fn {_k, v} -> v === player end)
      |> find_adjacent(nx, :horizontal)

    print_board(map, nx, ny)
  end

  def find_adjacent(map, nx, direction) do
    diff = case direction do
      :vertical -> nx
      :horizontal -> 1
      :diagonal_right -> nx + 1
      :diagonal_left -> nx - 1
    end

    find_adjacent(Map.keys(map), nx, diff, 0, 1)
  end
      
  def find_adjacent(values, _nx, _diff, start_index, consecutive) when
    length(values) <= start_index + 1
  do
    {Enum.at(values, start_index), consecutive}
  end

  def find_adjacent(values, nx, diff, start_index, consecutive) do
    start = Enum.at(values, start_index)
    adj = Enum.find(values, fn x ->
      row_diff = if diff === 1 do 0 else consecutive end
      next = start + consecutive * diff
      next === x and get_row(next, nx) - get_row(start, nx) === row_diff
    end)

    cond do
      consecutive === 4 -> {start, consecutive}
      adj !== nil -> find_adjacent(values, nx, diff, start_index, consecutive + 1)
      true -> find_adjacent(values, nx, diff, start_index + 1, 1)
    end
  end

  # 1-indexed
  defp get_row(x, diff) do
    if x < 0 do 0 else 1 + get_row(x - diff, diff) end
  end

  def create_board(nx, ny) do
    len = nx * ny - 1
    Map.new(0..len, &{&1, nil})
  end

  def print_board(board, nx, ny) do
    Enum.reduce(ny-1..0, "", fn y, acc_row ->
      acc_row
        <> Enum.reduce(0..nx-1, "", fn x, acc_col ->
          piece = board[x + y * nx]
          acc_col <> case piece do nil -> " -"; _ -> " #{piece}" end
        end)
        <> "\n"
    end)
    |> IO.puts
  end

  def add_winning_positions(map) do
    %{ map | 0 => 0, 1 => 1, 2 => 0, 3 => 1, 4 => 0, 5 => 1, 6 => 0, 8 => 1, 9 => 0, 10 => 1, 11 => 0, 16 => 0, 17 => 1, 18 => 0, 24 => 1, 30 => 1 }
  end

  def create_board(:nested, nx, ny) do
    # Create nx no. of cols
    col = Enum.into(0..ny-1, %{}, &{&1, nil})
    Enum.into(0..nx-1, %{}, &{&1, col})
  end
end
