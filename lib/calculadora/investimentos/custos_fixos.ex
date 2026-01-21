defmodule Calculadora.Investimento.CustosFixos do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:condominio, :float)
    field(:iptu_mensal, :float)
    field(:seguro, :float)
    field(:manutencao_estimada, :float)
  end

  def changeset(custos_fixos, attrs) do
    custos_fixos
    |> cast(attrs, [:condominio, :iptu_mensal, :seguro, :manutencao_estimada])
    |> validate_required([:condominio, :iptu_mensal, :seguro, :manutencao_estimada])
    |> validate_number(:condominio, greater_than_or_equal_to: 0)
    |> validate_number(:iptu_mensal, greater_than_or_equal_to: 0)
    |> validate_number(:seguro, greater_than_or_equal_to: 0)
    |> validate_number(:manutencao_estimada, greater_than_or_equal_to: 0)
  end
end
