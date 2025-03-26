defmodule Fourx do
  @type board_piece :: nil | 0 | 1

  def board do
    map = create_board(7, 6)
    map
  end

  def create_board(nx, ny) do
    # Create nx no. of cols
    col = Enum.into(0..ny-1, %{}, &{&1, nil})
    Enum.into(0..nx-1, %{}, &{&1, col})
  end
end
