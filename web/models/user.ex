defmodule Bndrys.User do
  use Bndrys.Web, :model

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string
    field :thumb, :string
    field :cover, :string
    field :entered_password, :string, virtual: true

    timestamps
  end

  @derive {Poison.Encoder, only: [:id, :username, :email, :thumb, :cover]}

  @required_fields ~w(username email password)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:entered_password, min: 5)
    |> validate_confirmation(:entered_password, message: "Password does not match")
    |> unique_constraint(:email, message: "Email already taken")
    |> unique_constraint(:username, message: "Username already taken")
    |> generate_encrypted_password
  end

  defp generate_encrypted_password(current_changeset) do
    case current_changeset do
      %Ecto.Changeset{valid?: true, changes: %{entered_password: entered_password}} ->
        put_change(current_changeset, :password, Comeonin.Bcrypt.hashpwsalt(entered_password))
      _ ->
        current_changeset
    end
  end
end
