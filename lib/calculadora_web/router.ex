defmodule CalculadoraWeb.Router do
  use CalculadoraWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", CalculadoraWeb do
    pipe_through(:api)
    post("/analise-investimento", AnaliseInvestimentoController, :create)
  end
end
