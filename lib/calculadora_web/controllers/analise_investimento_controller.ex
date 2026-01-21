defmodule CalculadoraWeb.AnaliseInvestimentoController do
  use CalculadoraWeb, :controller

  alias Calculadora.Investimento
  alias Calculadora.Investimento.Calculos

  def create(conn, params) do
    changeset = Investimento.changeset(%Investimento{}, params)

    if changeset.valid? do
      investimento = Ecto.Changeset.apply_changes(changeset)
      resultado = Calculos.analisar(investimento)
      json(conn, resultado)
    else
      json(conn, %{
        status: "error",
        errors: changeset.errors
      })
    end
  end
end
