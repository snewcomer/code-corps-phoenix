defmodule CodeCorps.Validators.SlugValidatorTest do
  use ExUnit.Case, async: true

  import CodeCorps.Validators.SlugValidator

  test "with only letters" do
    changeset =
      "testslug" # can't be `slug` because reserved
      |> cast_slug
      |> validate_slug(:slug)
    assert changeset.valid?
  end

  test "with prefixed underscores" do
    changeset =
      "_slug"
      |> cast_slug
      |> validate_slug(:slug)
    assert changeset.valid?
  end

  test "with suffixed underscores" do
    changeset =
      "slug_"
      |> cast_slug
      |> validate_slug(:slug)
    assert changeset.valid?
  end

  test "with prefixed numbers" do
    changeset =
      "123slug"
      |> cast_slug
      |> validate_slug(:slug)
    assert changeset.valid?
  end

  test "with suffixed numbers" do
    changeset =
      "slug123"
      |> cast_slug
      |> validate_slug(:slug)
    assert changeset.valid?
  end

  test "with multiple dashes" do
    changeset =
      "slug-slug-slug"
      |> cast_slug
      |> validate_slug(:slug)
    assert changeset.valid?
  end

  test "with multiple underscores" do
    changeset =
      "slug_slug_slug"
      |> cast_slug
      |> validate_slug(:slug)
    assert changeset.valid?
  end

  test "with multiple consecutive underscores" do
    changeset =
      "slug___slug"
      |> cast_slug
      |> validate_slug(:slug)
    assert changeset.valid?
  end

  test "with one character" do
    changeset =
      "s"
      |> cast_slug
      |> validate_slug(:slug)
    assert changeset.valid?
  end

  test "with prefixed symbols" do
    changeset =
      "@slug"
      |> cast_slug
      |> validate_slug(:slug)
    refute changeset.valid?
  end

  test "with prefixed dashes" do
    changeset =
      "-slug"
      |> cast_slug
      |> validate_slug(:slug)
    refute changeset.valid?
  end

  test "with suffixed dashes" do
    changeset =
      "slug-"
      |> cast_slug
      |> validate_slug(:slug)
    refute changeset.valid?
  end

  test "with multiple consecutive dashes" do
    changeset =
      "slug---slug"
      |> cast_slug
      |> validate_slug(:slug)
    refute changeset.valid?
  end

  test "with single slashes" do
    changeset =
      "slug/slug"
      |> cast_slug
      |> validate_slug(:slug)
    refute changeset.valid?
  end

  test "with multiple slashes" do
    changeset =
      "slug/slug/slug"
      |> cast_slug
      |> validate_slug(:slug)
    refute changeset.valid?
  end

  test "with multiple consecutive slashes" do
    changeset =
      "slug///slug"
      |> cast_slug
      |> validate_slug(:slug)
    refute changeset.valid?
  end

  test "with reserved routes" do
    changeset =
      "about"
      |> cast_slug
      |> validate_slug(:slug)
    refute changeset.valid?
  end

  defp cast_slug(slug) do
    Ecto.Changeset.cast({%{slug: nil}, %{slug: :string}}, %{"slug" => slug}, [:slug])
  end
end
