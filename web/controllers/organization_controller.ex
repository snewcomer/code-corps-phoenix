defmodule CodeCorps.OrganizationController do
  use CodeCorps.Web, :controller

  alias CodeCorps.Organization
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    organizations = Repo.all(Organization)
    render(conn, "index.json-api", data: organizations)
  end

  def create(conn, %{"data" => data = %{"type" => "organization", "attributes" => _organization_params}}) do
    changeset = Organization.changeset(%Organization{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, organization} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", organization_path(conn, :show, organization))
        |> render("show.json-api", data: organization)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(CodeCorps.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    organization = Repo.get!(Organization, id)
    render(conn, "show.json-api", data: organization)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "organization", "attributes" => _organization_params}}) do
    organization = Repo.get!(Organization, id)
    changeset = Organization.changeset(organization, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, organization} ->
        render(conn, "show.json-api", data: organization)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(CodeCorps.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

end
