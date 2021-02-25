defmodule Rocketpay.User.Create do
  alias Ecto.Multi
  alias Rocketpay.{Account, Repo, User}

  def call(params) do
    Multi.new()
    |> Multi.insert(:create_user, User.changeset(params))
    |> Multi.run(:create_account, fn repo, %{create_user: user} ->
      insert_account(user, repo)
    end)
    |> Multi.run(:preload_data, fn repo, %{create_user: user} ->
      preload_data(user, repo)
    end)
    |> run_transaction()
  end

  defp insert_account(user, repo) do
    user.id
    |> accout_changeset()
    |> repo.insert()
  end

  defp accout_changeset(user_id) do
    %{user_id: user_id, balance: "0.00"}
    |> Account.changeset()
  end

  defp preload_data(user, repo) do
    {:ok, repo.preload(user, :account)}
  end

  defp run_transaction(multi) do
    IO.inspect(Repo.transaction(multi))

    case Repo.transaction(multi) do
      {:error, _òperations, reason, _changes} -> {:error, reason}
      {:ok, %{preload_data: user}} -> {:ok, user}
    end
  end
end
