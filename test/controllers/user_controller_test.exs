defmodule CodeCorps.UserControllerTest do
  use CodeCorps.ConnCase

  alias CodeCorps.User
  alias CodeCorps.Repo

  @valid_attrs %{
    email: "test@user.com",
    username: "testuser",
  }
  @invalid_attrs %{
    email: "",
    username: "",
  }

  setup do
    conn =
      %{build_conn | host: "api."}
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  defp relationships do
    %{}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    user = insert_user()
    conn = get conn, user_path(conn, :show, user)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{user.id}"
    assert data["type"] == "user"
    assert data["attributes"]["username"] == user.username
    assert data["attributes"]["email"] == user.email
    assert data["attributes"]["password"] == nil
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    attrs = Map.put(@valid_attrs, :password, "password")
    conn = post conn, user_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "user",
        "attributes" => attrs,
        "relationships" => relationships
      }
    }

    id = json_response(conn, 201)["data"]["id"]
    assert id
    assert Repo.get(User, id)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "user",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    user = insert_user()
    attrs = Map.put(@valid_attrs, :password, "password")
    conn = put conn, user_path(conn, :update, user), %{
      "meta" => %{},
      "data" => %{
        "type" => "user",
        "id" => user.id,
        "attributes" => attrs,
        "relationships" => relationships
      }
    }

    id = json_response(conn, 200)["data"]["id"]
    assert id
    assert Repo.get(User, id)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user = insert_user()
    conn = put conn, user_path(conn, :update, user), %{
      "meta" => %{},
      "data" => %{
        "type" => "user",
        "id" => user.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    user = insert_user()
    conn = delete conn, user_path(conn, :delete, user)
    assert response(conn, 204)
    refute Repo.get(User, user.id)
  end
end
