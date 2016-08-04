defmodule CodeCorps.SluggedRouteView do
  use CodeCorps.Web, :view
  use JaSerializer.PhoenixView

  attributes [:slug, :organization_id, :user_id, :inserted_at, :updated_at]
  

end
