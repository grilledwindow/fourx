defmodule Fourx do
  @type board_piece :: nil | 0 | 1

  def board do
    _map = create_board(:flat, 7, 6)
      |> add_winning_positions(:flat)
      |> Map.filter(fn {_k, v} -> v !== nil end)
  end

  def create_board(nx, ny) do
    # Create nx no. of cols
    col = Enum.into(0..ny-1, %{}, &{&1, nil})
    Enum.into(0..nx-1, %{}, &{&1, col})
  end

  def create_board(:flat, nx, ny) do
    len = nx * ny - 1
    Map.new(0..len, &{&1, nil})
  end

  def add_winning_positions(map, :flat) do
    %{ map | 0 => 0, 1 => 1, 2 => 0, 3 => 1, 4 => 0, 5 => 1, 6 => 0, 8 => 1, 9 => 0, 10 => 1, 11 => 0, 16 => 0, 17 => 1, 18 => 0, 24 => 1 }
  end
end
