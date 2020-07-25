defmodule TapRacer.Utils do
  def generate_id do
    :rand.uniform(0xFF_FFFF_FFFF)
    |> Integer.to_string(32)
    |> String.downcase()
    |> String.pad_leading(8, "0")
  end
end
