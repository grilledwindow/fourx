defmodule Fourx do
  @type board_piece :: nil | 0 | 1

  def board do
    player = 1
    {nx, ny} = {7, 6}
    map = create_board(nx, ny)
      |> add_winning_positions
      |> Map.filter(fn {_k, v} -> v === player end)

    find_adjacent(map, nx)
  end

  def find_adjacent(map, nx), do: find_adjacent(Map.keys(map), nx, 0, 1)
  def find_adjacent(values, _nx, start, consecutive) when
    length(values) <= 1
    or length(values) <= start + consecutive
  do
    {start, consecutive}
  end

  def find_adjacent(values, nx, start_index, consecutive) do
    start = Enum.at(values, start_index)
    adj = Enum.find(values, &(&1 === (start + consecutive * nx)))

    cond do
      consecutive === 4 -> {start, consecutive}
      adj !== nil -> find_adjacent(values, nx, start_index, consecutive + 1)
      true -> find_adjacent(values, nx, start_index + 1, 1)
    end
  end

  def create_board(nx, ny) do
    len = nx * ny - 1
    Map.new(0..len, &{&1, nil})
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
