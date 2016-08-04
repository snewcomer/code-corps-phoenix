defmodule CodeCorps.Organization do
  use CodeCorps.Web, :model

  schema "organizations" do
    field :name, :string
    field :description, :string
    field :slug, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :slug])
    |> validate_required([:name, :description, :slug])
  end
end
