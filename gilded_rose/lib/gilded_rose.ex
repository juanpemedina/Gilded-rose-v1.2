defmodule GildedRose do
  def update_quality(items) do
    Enum.map(items, &update_item/1)
  end

  defp decrease_quality(%{name: "Sulfuras, Hand of Ragnaros"} = item), do: item
  defp decrease_quality(%{quality: quality} = item) when quality > 0, do: %{item | quality: quality - 1}
  defp decrease_quality(item), do: item

  defp increase_quality(%{quality: quality} = item) when quality < 50, do: %{item | quality: quality + 1}
  defp increase_quality(item), do: item

  defp decrease_sell_in(%{name: "Sulfuras, Hand of Ragnaros"} = item), do: item
  defp decrease_sell_in(%{sell_in: sell_in} = item), do: %{item | sell_in: sell_in - 1}

  defp handle_expired(%{name: "Backstage passes to a TAFKAL80ETC concert"} = item), do: %{item | quality: 0}
  defp handle_expired(%{name: "Aged Brie", quality: quality} = item) when quality < 50, do: %{item | quality: quality + 1}
  defp handle_expired(item), do: decrease_quality(item)

  defp update_aged_brie(item) do
    item
    |> increase_quality()
    |> decrease_sell_in()
    |> handle_expiration()
  end

  defp update_backstage_pass(item) do
    item
    |> apply_backstage_quality_increase()
    |> decrease_sell_in()
    |> handle_expiration()
  end

  defp apply_backstage_quality_increase(%{sell_in: sell_in, quality: quality} = item) do
    cond do
      sell_in <= 5 -> %{item | quality: min(quality + 3, 50)}
      sell_in <= 10 -> %{item | quality: min(quality + 2, 50)}
      true -> increase_quality(item)
    end
  end

  defp handle_expiration(%{sell_in: sell_in} = item) do
    if sell_in < 0, do: handle_expired(item), else: item
  end

  def update_item(%{name: "Aged Brie"} = item), do: update_aged_brie(item)
  def update_item(%{name: "Backstage passes to a TAFKAL80ETC concert"} = item), do: update_backstage_pass(item)
  def update_item(item) do
    item
    |> decrease_quality()
    |> decrease_sell_in()
    |> handle_expiration()
  end
end
