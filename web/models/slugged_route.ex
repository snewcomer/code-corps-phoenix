defmodule CodeCorps.SluggedRoute do
  use CodeCorps.Web, :model

  schema "slugged_routes" do
    field :slug, :string
    field :organization_id, :integer
    field :user_id, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:slug, :organization_id, :user_id])
    |> validate_required([:slug, :organization_id, :user_id])
  end
end
