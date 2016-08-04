defmodule CodeCorps.OrganizationControllerTest do
  use CodeCorps.ConnCase

  alias CodeCorps.Organization
  alias CodeCorps.Repo

  @valid_attrs %{description: "Build a better future.", name: "Code Corps", slug: "code-corps"}
  @invalid_attrs %{}

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
    conn = get conn, organization_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    organization = Repo.insert! %Organization{}
    conn = get conn, organization_path(conn, :show, organization)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{organization.id}"
    assert data["type"] == "organization"
    assert data["attributes"]["name"] == organization.name
    assert data["attributes"]["description"] == organization.description
    assert data["attributes"]["slug"] == organization.slug
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, organization_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "organization",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Organization, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, organization_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "organization",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    organization = Repo.insert! %Organization{}
    conn = put conn, organization_path(conn, :update, organization), %{
      "meta" => %{},
      "data" => %{
        "type" => "organization",
        "id" => organization.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Organization, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    organization = Repo.insert! %Organization{}
    conn = put conn, organization_path(conn, :update, organization), %{
      "meta" => %{},
      "data" => %{
        "type" => "organization",
        "id" => organization.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

end
