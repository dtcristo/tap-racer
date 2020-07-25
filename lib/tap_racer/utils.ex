defmodule TapRacer.Utils do
  def generate_id do
    :rand.uniform(0x10_0000)
    |> Integer.to_string(32)
    |> String.downcase()
    |> String.pad_leading(4, "0")
  end
end
