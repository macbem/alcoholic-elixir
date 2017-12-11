defmodule AlcoholicElixir.API do
  @moduledoc """
  This module serves as an API interface for the Alcoholic Elixir app and fetches data from PunkApi
  """

  @api_url "https://api.punkapi.com/v2/beers"

  defp get_api_url(endpoint), do: "#{get_api_url()}/#{endpoint}"
  defp get_api_url(), do: @api_url

  @doc """
  Entry method - constructs the needed API link and passes it to the query runner
  """
  def fetch(:id, id) do
    get_api_url(id)
    |> do_fetch
  end

  def fetch(:random) do
    get_api_url("random")
    |> do_fetch
  end

  def fetch() do
    get_api_url()
    |> do_fetch
  end

  defp do_fetch(api_url) do
    api_url
    |> HTTPoison.get
    |> extract_body
    |> parse_response
  end

  @doc """
  Extracts useful data from the response
  """
  def parse_response({:ok, beers}) when is_list(beers) do
    for beer <- beers, do: parse_response beer
  end

  def parse_response({:ok, beer}) do
    %{
      name: beer["name"],
      id: beer["id"],
      tagline: beer["tagline"]
    }
  end

  def parse_response({:error, reason}) do
    {:error, reason}
  end

  def parse_response(beer) do
    %{
      name: beer["name"],
      id: beer["id"],
      tagline: beer["tagline"]
    }
  end

  defp extract_body({:ok, %{status_code: 200, body: body}}) do
    {:ok, Poison.Parser.parse!(body)}
  end

  defp extract_body({_, %{status_code: 404, body: _}}) do
    {:error, "No such beer was found."}
  end

  defp extract_body({:error, _}) do
    {:error, "Something went wrong, check your internet connection."}
  end
end
