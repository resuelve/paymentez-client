defmodule PaymentezClient.User do
  @enforce_keys [:id, :email]
  defstruct id: nil,
            email: nil
end

defmodule PaymentezClient.CashOrder do
  @enforce_keys [:dev_reference, :amount, :description]
  defstruct dev_reference: nil,
            amount: nil,
            expiration_days: 3,
            recurrent: false,
            description: nil
end
