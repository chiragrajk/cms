defmodule Cms.Auth.Accounts do
  import Ecto.Query
  import Plug.Conn

  alias Cms.Repo
  alias Cms.Auth.{User, Guardian}
  alias Comeonin.Bcrypt

  def get_user(id), do: Repo.get(User, id)

  def get_current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end

  def authenticate_user(email, given_password) do
    query = from(u in User, where: u.email == ^email)
    Repo.one(query)
    |> check_password(given_password)
  end

  def login(conn, user) do
    conn
    |> Guardian.Plug.sign_in(user)
    |> assign(:current_user, user)
  end

  def logout(conn) do
    conn
    |> Guardian.Plug.sign_out()
    
  end

  # Private
  defp check_password(nil, _), do: {:error, "Incorect email or password"}
  defp check_password(user, given_password) do
    case Bcrypt.checkpw(given_password, user.password_hash) do
      true -> {:ok, user}
      false -> {:error, "Incorrect email or password"}
    end
  end
end