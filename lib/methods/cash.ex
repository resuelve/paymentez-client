defmodule PaymentezClient.Methods.Cash do
  @moduledoc """
  Módulo para crear pagos en efectivo (Solo colombia por ahora)
  """

  alias PaymentezClient.User
  alias PaymentezClient.CashOrder
  alias PaymentezClient.Auth

  require Logger

  def create_order(user_id, user_email, amount, description, reference) do
    user = %User{
      id: user_id,
      email: user_email
    }
    order = %CashOrder{
      dev_reference: reference,
      amount: amount,
      description: description
    }

    case _post_order(user, order) do
      {:ok, response} ->
         _map_response(response)
      {:error, error} ->
        Logger.error "Tesla error: #{inspect error}"
        {:error, error}
    end
  end

  # Mapea el response a una forma mas facil de entender para indetificar si es
  # error o no
  @spec _map_response(map) :: tuple
  defp _map_response(%Tesla.Env{body: body, status: status}) when status == 200 do
    {:ok, body}
  end

  defp _map_response(%Tesla.Env{body: body, status: _status}) do
    Logger.error "Paymentez error: #{inspect body}"
    {:error, body}
  end

  # Manda a llamar el WS de Paymentez para crear una orden de pago en efectivo
  @spec _post_order(map, map) :: map
  defp _post_order(user, order) do
    url = Application.get_env(:paymentez, :base_url) <> "/order"
    data = Poison.encode(_build_body(user, order))
    token = Auth.get_token()

    Tesla.post(
      url,
      data,
      headers: [
        {"content-type", "application/json"},
        {"Auth-Token", token}
      ]
    )
  end

  # Genera body para request
  @spec _build_body(map, map) :: map
  defp _build_body(user, order) do
    %{
      "carrier" => %{
        "id" => "payvalida"
      },
      "user" => user,
      "order" => order
    }
  end
end
