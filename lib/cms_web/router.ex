defmodule CmsWeb.Router do
  use CmsWeb, :router

  alias Cms.Plug

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Plug.Authentication
  end

  pipeline :authenticated do
    plug Plug.EnsureAuthentication
    plug Plug.Sidebar
  end

  scope "/admin", CmsWeb, as: :admin do
    pipe_through [:browser, :authenticated]
    get "/", Admin.HomeController, :index
  end

  scope "/", CmsWeb do
    pipe_through :browser

    resources("/session", SessionController, only: [:create, :new, :delete])
    resources("/", PageController, only: [:index, :show])
  end

  # Other scopes may use custom stacks.
  # scope "/api", CmsWeb do
  #   pipe_through :api
  # end
end
