defmodule GildedRose do
  def update_quality(items) do
    Enum.map(items, &update_item/1)
  end

  # Función auxiliar para disminuir la calidad
  defp decrease_quality(%{name: "Sulfuras, Hand of Ragnaros"} = item), do: item
  defp decrease_quality(%{quality: quality} = item) when quality > 0, do: %{item | quality: quality - 1}
  defp decrease_quality(item), do: item

  # Función auxiliar para aumentar la calidad
  defp increase_quality(%{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: sell_in, quality: quality} = item) when quality < 50 do
    quality_increase = 
      cond do
        sell_in < 6 -> 3
        sell_in < 11 -> 2
        true -> 1
      end
    
    %{item | quality: min(50, quality + quality_increase)}
  end

  defp increase_quality(%{quality: quality} = item) when quality < 50, do: %{item | quality: quality + 1}
  defp increase_quality(item), do: item

  # Función auxiliar para reducir sell_in
  defp decrease_sell_in(%{name: "Sulfuras, Hand of Ragnaros"} = item), do: item
  defp decrease_sell_in(%{sell_in: sell_in} = item), do: %{item | sell_in: sell_in - 1}

  # Función auxiliar para manejar los artículos vencidos
  defp handle_expired(%{name: "Backstage passes to a TAFKAL80ETC concert"} = item), do: %{item | quality: 0}
  defp handle_expired(%{name: "Aged Brie", quality: quality} = item) when quality < 50, do: %{item | quality: quality + 1}
  defp handle_expired(item), do: decrease_quality(item)

  def update_item(item) do
    # Actualización de calidad
    item = cond do
      item.name == "Aged Brie" || item.name == "Backstage passes to a TAFKAL80ETC concert" ->
        increase_quality(item)
      item.name != "Aged Brie" && item.name != "Backstage passes to a TAFKAL80ETC concert" ->
        decrease_quality(item)
      true -> item
    end

    # Reducción de sell_in
    item = decrease_sell_in(item)

    # Lógica de artículos vencidos, usando la nueva función auxiliar
    if item.sell_in < 0, do: handle_expired(item), else: item
  end
end
