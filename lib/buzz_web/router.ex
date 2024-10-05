defmodule BuzzWeb.Router do
  use BuzzWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BuzzWeb do
    pipe_through :api
  end
end
