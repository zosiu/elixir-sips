defmodule Schizo do
  @moduledoc false

  @doc ~S"""
  Upcases every other word in a sentece.

  ## Examples

      iex> Schizo.uppercase("elixir is pretty rad")
      "elixir IS pretty RAD"

  """
  def uppercase(str) do
    str |> transform_every_other_word_with(&String.upcase/1)
  end

  @doc ~S"""
  Removes the vowels from every other word in a sentence.

  ## Examples

      iex> Schizo.unvowel("how are things really?")
      "how r things rlly?"

  """
  def unvowel(str) do
    str |> transform_every_other_word_with(fn item ->
      String.replace(item, ~r/[aiueo]/, "") end)
  end

  defp transform_every_other_word_with(str, transformer) do
    str
    |> String.split(" ")
    |> transform_every_other_item_with(transformer)
    |> Enum.join(" ")
  end

  defp transform_every_other_item_with(list, transformer) do
    list
    |> Stream.with_index
    |> Enum.map(transform_odd_index_item_with(transformer))
  end

  defmacrop is_even(int) do
    quote do: rem(unquote(int), 2) == 0
  end

  defmacrop is_odd(int) do
    quote do: rem(unquote(int), 2) == 1
  end

  defp transform_odd_index_item_with(transformer) do
    fn
      ({item, index}) when is_even(index) -> item
      ({item, index}) when is_odd(index) -> transformer.(item)
    end
  end
end