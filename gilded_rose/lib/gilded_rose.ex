defmodule GildedRose do
  # Example
  # update_quality([%Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 9, quality: 1}])
  # => [%Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 8, quality: 3}]

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

    # Ajuste final de calidad si el ítem ya está vencido
    cond do
      item.sell_in < 0 ->
        cond do
          item.name != "Aged Brie" && item.name != "Backstage passes to a TAFKAL80ETC concert" ->
            decrease_quality(item)
          item.name == "Backstage passes to a TAFKAL80ETC concert" ->
            %{item | quality: 0}
          item.name == "Aged Brie" && item.quality < 50 ->
            %{item | quality: item.quality + 1}
          true -> item
        end
      true -> item
    end
  end
end
