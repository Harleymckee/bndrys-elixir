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

  @required_fields ~w(name email password)
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
    |> validate_length(:password, min: 5)
    |> validate_confirmation(:password, message: "Password does not match")
    |> unique_constraint(:email, message: "Email already taken")
    |> unique_constraint(:username, message: "Username already taken")
  end
end
