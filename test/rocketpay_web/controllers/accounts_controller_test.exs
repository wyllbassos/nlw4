defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.{Account, User}

  describe "deposit/2" do
    setup %{conn: conn} do
      params = %{
        name: "Wylliam",
        password: "colorado",
        nickname: "wyllbassos",
        email: "teste@www.com",
        age: 31
      }

      # Base.encode64(nickname:password) => d3lsbGJhc3Nvczpjb2xvcmFkbw==

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

      conn = put_req_header(conn, "authorization", "Basic d3lsbGJhc3Nvczpjb2xvcmFkbw==")

      {:ok, conn: conn, account_id: account_id}
    end

    test "when all params aer valid, make the deposi", %{conn: conn, account_id: account_id} do
      params = %{"value" => "50.00"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:ok)

      assert %{
               "account" => %{
                 "balance" => "50.00",
                 "id" => _id
               },
               "message" => "Ballance changed successfully"
             } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn, account_id: account_id} do
      params = %{"value" => "test"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:bad_request)

      expected_responde = %{"message" => "Invalid operation value!"}

      assert response == expected_responde
    end
  end
end
