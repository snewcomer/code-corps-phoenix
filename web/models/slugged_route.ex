defmodule CodeCorps.SluggedRoute do
  use CodeCorps.Web, :model

  import CodeCorps.Validators.SlugValidator

  schema "slugged_routes" do
    belongs_to :organization, CodeCorps.Organization
    belongs_to :user, CodeCorps.User

    field :slug, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:slug])
    |> validate_required(:slug)
    |> validate_slug(:slug)
  end

  @doc """
  Builds a changeset for when the owner of the slugged route is
  an organization.
  """
  def organization_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> cast(params, [:organization_id])
    |> validate_required(:organization_id)
  end

  @doc """
  Builds a changeset for when the owner of the slugged route is
  a user.
  """
  def user_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> cast(params, [:user_id])
    |> validate_required(:user_id)
  end
end
