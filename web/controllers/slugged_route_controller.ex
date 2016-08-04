defmodule CodeCorps.SluggedRouteController do
  use CodeCorps.Web, :controller

  alias CodeCorps.SluggedRoute
  alias JaSerializer.Params

  def show(conn, %{"slug" => slug}) do
    slugged_route = Repo.get_by!(SluggedRoute, slug: slug)
    render(conn, "show.json-api", data: slugged_route)
  end
end
