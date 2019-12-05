defmodule TargetMvdWeb.API.V1.TargetView do
  use TargetMvdWeb, :view
  alias TargetMvdWeb.API.V1.TargetView

  def render("index.json", %{targets: targets}) do
    %{data: render_many(targets, TargetView, "target.json")}
  end

  def render("show.json", %{target: target}) do
    %{data: render_one(target, TargetView, "target.json")}
  end

  def render("target.json", %{target: target}) do
    %{
      id: target.id,
      title: target.title,
      radius: target.radius,
      latitude: target.latitude,
      longitude: target.longitude
    }
  end

  def render("target_limit_reached.json", _) do
    %{errors: %{detail: "Target maximum limit reached"}}
  end
end
