defmodule CodeCorps.User do
  use CodeCorps.Web, :model

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :username])
    |> validate_required([:email, :username])
    |> validate_length(:username, min: 1, max: 39)
  end

  @doc """
  Builds a changeset for registering the user.
  """
  def registration_changeset(struct, params) do
    struct
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required(:password)
    |> validate_length(:password, min: 6)
    |> put_pass_hash()
  end

  def check_email_availability(email) do
    %{}
    |> check_email_valid(email)
    |> check_used(:email, email)
  end

  def check_username_availability(username) do
    %{}
    |> check_username_valid(username)
    |> check_used(:username, username)
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end

  defp check_email_valid(struct, email) do
    put_in struct[:valid], Regex.match?(~r/@/, email)
  end

  defp check_username_valid(struct, username) do
    put_in struct[:valid], String.length(username) >= 1 && String.length(username) <= 39
  end

  defp check_used(struct, column, value) do
    query = from u in "users", where: field(u, ^column) == ^value, select: field(u, ^column)
    available = CodeCorps.Repo.all(query) |> Enum.empty?

    put_in struct[:available], CodeCorps.Repo.all(query) |> Enum.empty?
  end
end
