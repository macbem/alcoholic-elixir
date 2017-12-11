defmodule AlcoholicElixir.CLI do
  @moduledoc """
  This module serves as a CLI interface for the Alcoholic Elixir app to be used w/ Escript
  """

  @doc """
  Main entry point for Escript
  """
  def main(args) do
    args
    |> parse_args
    |> process
    |> log_results
  end

  defp parse_args(args) do
    parsed_args = OptionParser.parse(args, switches: [help: :boolean, id: :number, random: :boolean], aliases: [h: :help])

    case parsed_args do
      {[help: true], _, _}
        -> {:help}
      {[id: id], _, _}
        -> {:id, id}
      {[random: true], _, _}
        -> {:random}
      {_, [], _}
        -> {:noparams}
    end
  end

  defp process({:help}) do
    """
      A very simple CLI interface for PunkAPI.

      Opts:
      - --random - get a random beer
      - --id <id> - get a beer with a given id
      - --help - display this help message
      - no params - get a list of beers
    """
  end

  defp process({:id, id}) do
    IO.inspect id

    AlcoholicElixir.API.fetch(:id, id)
  end

  defp process({:random}) do
    IO.inspect "random"

    AlcoholicElixir.API.fetch(:random)
  end

  defp process({:noparams}) do
    IO.inspect "no query"

    AlcoholicElixir.API.fetch()
  end

  defp process(:help) do
    help_text = """
    This utility shows beer information.
    Usage:
      - <beer_id> - it will try to find a beer with this id or return 404
      - --random - it will return a random beer from the database
      - --similar <beer_id> - it will return beers similar to the chosen one from the database
      - no params - it will return a list of beers
    """
    help_text
    |> String.trim
    |> IO.puts
  end

  defp log_results(message) when is_bitstring(message) do
    IO.puts message
  end

  defp log_results({:error, reason}) do
    IO.puts "There was an error:"
    IO.inspect reason
  end

  defp log_results(beers) when is_list(beers) do
     for beer <- beers do
       IO.puts "Beer:"
       IO.puts("  name: #{beer.name}")
       IO.puts("  tagline: #{beer.tagline}")
       IO.puts("  id: #{beer.id} \n")
     end
  end
end
