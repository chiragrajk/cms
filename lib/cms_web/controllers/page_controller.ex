defmodule CmsWeb.PageController do
  use CmsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
