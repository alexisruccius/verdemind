defmodule Verdemind.RepoTest do
  use ExUnit.Case

  describe "config/0" do
    test "otp_app configured" do
      assert Verdemind.Repo.config() |> Keyword.get(:otp_app) == :verdemind
    end

    test "uses test database" do
      assert Verdemind.Repo.config() |> Keyword.get(:database) == "verdemind_test"
    end
  end

  describe "all/1" do
    test "returns a list" do
      # ownership for process (else: DBConnection.OwnershipError)
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(Verdemind.Repo)
      assert Verdemind.Repo.all(Verdemind.Botany.Plant) == []
      assert Verdemind.Repo.in_transaction?() == false
      assert Verdemind.Repo.checked_out?() == false
    end
  end

  test "has Ecto behaviour" do
    module_attrs = Verdemind.Repo.__info__(:attributes)
    assert module_attrs |> Keyword.get(:behaviour) == [Ecto.Repo]
    assert Verdemind.Repo.config() |> is_list()
  end
end
