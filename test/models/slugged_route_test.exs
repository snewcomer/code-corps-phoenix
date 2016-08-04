defmodule CodeCorps.SluggedRouteTest do
  use CodeCorps.ModelCase

  alias CodeCorps.SluggedRoute

  @valid_attrs %{organization_id: 42, slug: "some content", user_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = SluggedRoute.changeset(%SluggedRoute{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = SluggedRoute.changeset(%SluggedRoute{}, @invalid_attrs)
    refute changeset.valid?
  end
end
