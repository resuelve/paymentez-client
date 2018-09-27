defmodule PaymentezClient.Auth do
  @moduledoc """
  Genera un toke valido para autenticar con el servicio de Paymentez
  """

  require Logger

  @doc """
  Devuelve un token para autentiar con el servicio.
  Doc: https://paymentez.github.io/api-doc/#authentication
  """
  @spec get_token() :: String.t
  def get_token() do
    application_code = Application.get_env(:paymentez, :application_code)
    application_key = Application.get_env(:paymentez, :appliction_key)
    {unix_timestamp, hash} = _token_hash(application_key)
    "#{application_code};#{unix_timestamp};#{hash}"
    |> Base.encode64
  end

  # Genera un hash unico para validar token contra el servicio
  @spec _token_hash(String.t) :: tuple
  defp _token_hash(application_key) do
    unix_timestamp =
      DateTime.utc_now
      |> DateTime.to_unix
      |> Integer.to_string

    hash =
      :crypto.hash(:sha256, application_key <> unix_timestamp)
      |> Base.encode16
      |> String.downcase

    {unix_timestamp, hash}
  end
end
