defmodule CodeCorps.SluggedRoute do
  use CodeCorps.Web, :model

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
  end

  def organization_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> cast(params, [:organization_id])
    |> validate_required(:organization_id)
  end

  def user_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> cast(params, [:user_id])
    |> validate_required(:user_id)
  end
end
