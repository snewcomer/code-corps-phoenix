defmodule CodeCorps.Validators.SlugValidatorTest do
  use ExUnit.Case, async: true

  import CodeCorps.Validators.SlugValidator

  test "with only letters" do
    changeset = cast_slug("testslug") # can't be `slug` because reserved
    changeset = validate_slug(changeset, :slug)
    assert changeset.valid?
  end

  test "with preceding underscores" do
    changeset = cast_slug("_slug")
    changeset = validate_slug(changeset, :slug)
    assert changeset.valid?
  end

  test "with suffixed underscores" do
    changeset = cast_slug("slug_")
    changeset = validate_slug(changeset, :slug)
    assert changeset.valid?
  end

  test "with preceding numbers" do
    changeset = cast_slug("123slug")
    changeset = validate_slug(changeset, :slug)
    assert changeset.valid?
  end

  test "with suffixed numbers" do
    changeset = cast_slug("slug123")
    changeset = validate_slug(changeset, :slug)
    assert changeset.valid?
  end

  test "with multiple dashes" do
    changeset = cast_slug("slug-slug-slug")
    changeset = validate_slug(changeset, :slug)
    assert changeset.valid?
  end

  test "with multiple underscores" do
    changeset = cast_slug("slug_slug_slug")
    changeset = validate_slug(changeset, :slug)
    assert changeset.valid?
  end

  test "with multiple consecutive underscores" do
    changeset = cast_slug("slug___slug")
    changeset = validate_slug(changeset, :slug)
    assert changeset.valid?
  end

  test "with one character" do
    changeset = cast_slug("s")
    changeset = validate_slug(changeset, :slug)
    assert changeset.valid?
  end

  test "with preceding symbols" do
    changeset = cast_slug("@slug")
    changeset = validate_slug(changeset, :slug)
    refute changeset.valid?
  end

  test "with preceding dashes" do
    changeset = cast_slug("-slug")
    changeset = validate_slug(changeset, :slug)
    refute changeset.valid?
  end

  test "with suffixed dashes" do
    changeset = cast_slug("slug-")
    changeset = validate_slug(changeset, :slug)
    refute changeset.valid?
  end

  test "with multiple consecutive dashes" do
    changeset = cast_slug("slug---slug")
    changeset = validate_slug(changeset, :slug)
    refute changeset.valid?
  end

  test "with single salshes" do
    changeset = cast_slug("slug/slug")
    changeset = validate_slug(changeset, :slug)
    refute changeset.valid?
  end

  test "with multiple slashes" do
    changeset = cast_slug("slug/slug/slug")
    changeset = validate_slug(changeset, :slug)
    refute changeset.valid?
  end

  test "with multiple consecutive slashes" do
    changeset = cast_slug("slug///slug")
    changeset = validate_slug(changeset, :slug)
    refute changeset.valid?
  end

  test "with reserved routes" do
    changeset = cast_slug("about")
    changeset = validate_slug(changeset, :slug)
    refute changeset.valid?
  end

  defp cast_slug(slug) do
    Ecto.Changeset.cast({%{slug: nil}, %{slug: :string}}, %{"slug" => slug}, [:slug])
  end
end
