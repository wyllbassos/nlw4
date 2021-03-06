defmodule Rocketpay.Users.CreateTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.User
  alias Rocketpay.Users.Create

  describe "call/1" do
    test "when all params are valid, return an user" do
      params = %{
        name: "Wylliam",
        password: "colorado",
        nickname: "wyllbassos",
        email: "teste@www.com",
        age: 31
      }

      {:ok, %User{id: user_id}} = Create.call(params)
      user = Repo.get(User, user_id)
      assert %User{name: "Wylliam", age: 31, id: ^user_id} = user
    end

    test "when there are invalid all params, return error" do
      params = %{
        name: "Wylliam",
        nickname: "wyllbassos",
        email: "teste@www.com",
        age: 15
      }

      {:error, changeset} = Create.call(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["can't be blank"]
      }

      assert expected_response == errors_on(changeset)
    end
  end
end
