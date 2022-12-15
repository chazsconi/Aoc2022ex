defmodule Day13 do
  def solve_part1 do
    File.read!("data/day13example.txt")
    # Split into sets of pairs
    |> String.split("\n\n")
    # Parse the pairs
    |> Enum.map(&parse_pairs/1)
    # Compare each pair
    |> Enum.map(fn {left, right} -> compare(left, right) end)
    # Index each result starting with 1
    |> Enum.with_index(1)
    # Filter out the correct results
    |> Enum.filter(fn {result, _index} -> result == :correct_order end)
    # Keep the index and discard the result
    |> Enum.map(fn {_result, index} -> index end)
    # Sum the indexes
    |> Enum.sum()
  end

  def solve_part2 do
    File.read!("data/day13example.txt")
    |> String.split("\n")
    # Remove blank lines
    |> Enum.reject(fn line -> line == "" end)
    # Parse each line
    |> Enum.map(&parse_line/1)
    |> append_divider_packets()
    # Sort using the the compare algorithm
    |> Enum.sort(fn left, right -> compare(left, right) == :correct_order end)
    # Index packets
    |> Enum.with_index(1)
    # Filter out divider packets
    |> Enum.filter(fn {packet, _index} -> packet == [[2]] or packet == [[6]] end)
    # Keep the index and discard the packets
    |> Enum.map(fn {_result, index} -> index end)
    # Multiply the result
    |> Enum.product()
  end

  defp append_divider_packets(packets), do: packets ++ [[[2]], [[6]]]

  defp parse_pairs(s) do
    [left_s, right_s] =
      s
      |> String.split("\n")

    left = parse_line(left_s)
    right = parse_line(right_s)

    {left, right}
  end

  defp parse_line(line) do
    {parsed, _} = Code.eval_string(line)
    parsed
  end

  defp compare([hd_l | tail_l], [hd_r | tail_r]) when is_integer(hd_l) and is_integer(hd_r) do
    cond do
      hd_l < hd_r -> :correct_order
      hd_l > hd_r -> :incorrect_order
      hd_l == hd_r -> compare(tail_l, tail_r)
    end
  end

  defp compare([hd_l | tail_l], [hd_r | tail_r]) when is_list(hd_l) and is_list(hd_r) do
    case compare(hd_l, hd_r) do
      :continue -> compare(tail_l, tail_r)
      :correct_order -> :correct_order
      :incorrect_order -> :incorrect_order
    end
  end

  defp compare([], []), do: :continue
  defp compare([], [_ | _]), do: :correct_order
  defp compare([_ | _], []), do: :incorrect_order

  defp compare(left, [hd_r | tail_r]) when is_integer(hd_r) do
    compare(left, [[hd_r] | tail_r])
  end

  defp compare([hd_l | tail_l], right) when is_integer(hd_l) do
    compare([[hd_l] | tail_l], right)
  end
end
