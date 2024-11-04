defmodule GildedRose do
  def update_quality(items) do
    Enum.map(items, &update_item/1)
  end

  def update_item(item) do
    item
    |> decrease_sell_in()
    |> increase_quality()
    |> handle_expiration()
  end

  defp decrease_quality(item = %{name: "Sulfuras, Hand of Ragnaros"}), do: item
  defp decrease_quality(%{quality: quality} = item) when quality > 0, do: %{item | quality: quality - 1}
  defp decrease_quality(item), do: item

  defp increase_quality(item = %{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: sell_in}) when sell_in <= 0, do: %{item | quality: 0}
  defp increase_quality(item = %{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: sell_in}) when sell_in <= 5, do: %{item | quality: min(item.quality + 3, 50)}
  defp increase_quality(item = %{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: sell_in}) when sell_in <= 10, do: %{item | quality: min(item.quality + 2, 50)}
  defp increase_quality(item = %{name: "Backstage passes to a TAFKAL80ETC concert"}), do: %{item | quality: min(item.quality + 1, 50)}
  defp increase_quality(item = %{name: "Aged Brie", quality: quality}) when quality < 50, do: %{item | quality: quality + 1}
  defp increase_quality(item = %{name: "Aged Brie"}), do: %{item | quality: 50}
  defp increase_quality(item), do: decrease_quality(item)

  defp decrease_sell_in(item = %{name: "Sulfuras, Hand of Ragnaros"}), do: item
  defp decrease_sell_in(%{sell_in: sell_in} = item), do: %{item | sell_in: sell_in - 1}

  defp handle_expired(item = %{name: "Backstage passes to a TAFKAL80ETC concert"}), do: %{item | quality: 0}
  defp handle_expired(item = %{name: "Aged Brie", quality: quality}) when quality < 50, do: %{item | quality: quality + 1}
  defp handle_expired(item), do: decrease_quality(item)

  defp handle_expiration(item = %{sell_in: sell_in}) when sell_in < 0, do: handle_expired(item)
  defp handle_expiration(item), do: item
end
