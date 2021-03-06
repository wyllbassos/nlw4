defmodule RocketpayWeb.UsersViewTest do
  use RocketpayWeb.ChannelCase, async: true

  import Phoenix.View

  alias Rocketpay.User
  alias Rocketpay.Account

  alias RocketpayWeb.UsersView

  test "render create.json" do
    params = %{
      name: "Wylliam",
      password: "colorado",
      nickname: "wyllbassos",
      email: "teste@www.com",
      age: 31
    }

    {:ok, %User{id: user_id, account: %Account{id: account_id}} = user} =
      Rocketpay.create_user(params)

    response = render(UsersView, "create.json", user: user)

    expected_response = %{
      message: "User created",
      user: %{
        account: %{balance: Decimal.new("0.00"), id: account_id},
        id: user_id,
        name: "Wylliam",
        nickname: "wyllbassos"
      }
    }

    assert response == expected_response
  end
end
