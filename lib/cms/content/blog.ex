defmodule Cms.Content.Blog do
  alias Cms.Content.Post
  alias Cms.Content.User
  alias Cms.Repo

  import Ecto.Query

  def get_published_posts() do
    Repo.all(
      from p in Post,
      where: p.published == true,
      preload: :user
    )
  end

  def get(slug) do
    Repo.get_by(Post, slug: slug)
  end

  def get(slug, true) do
    get(slug)
    |> Repo.preload([:user])
  end
  
end