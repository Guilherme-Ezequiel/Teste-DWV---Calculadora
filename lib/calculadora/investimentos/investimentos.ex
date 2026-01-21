defmodule Calculadora.Investimento do
  use Ecto.Schema
  import Ecto.Changeset

  alias Calculadora.Investimento.CustosFixos

  embedded_schema do
    field(:valor_imovel, :float)
    field(:entrada, :float)
    field(:taxa_juros_anual, :float)
    field(:prazo_financiamento_meses, :integer)
    field(:aluguel_mensal_esperado, :float)
    field(:taxa_vacancia_anual, :float)
    field(:valorizacao_anual_estimada, :float)

    embeds_one(:custos_fixos_mensais, CustosFixos)
  end

  def changeset(investimento, attrs) do
    investimento
    |> cast(attrs, [
      :valor_imovel,
      :entrada,
      :taxa_juros_anual,
      :prazo_financiamento_meses,
      :aluguel_mensal_esperado,
      :taxa_vacancia_anual,
      :valorizacao_anual_estimada
    ])
    |> validate_required([
      :valor_imovel,
      :entrada,
      :taxa_juros_anual,
      :prazo_financiamento_meses,
      :aluguel_mensal_esperado,
      :taxa_vacancia_anual,
      :valorizacao_anual_estimada
    ])
    |> validate_number(:valor_imovel, greater_than: 0)
    |> validate_number(:entrada, greater_than_or_equal_to: 0)
    |> validate_number(:taxa_juros_anual, greater_than_or_equal_to: 0)
    |> validate_number(:prazo_financiamento_meses, greater_than: 0)
    |> validate_number(:aluguel_mensal_esperado, greater_than_or_equal_to: 0)
    |> validate_number(:taxa_vacancia_anual, greater_than_or_equal_to: 0)
    |> validate_number(:valorizacao_anual_estimada, greater_than_or_equal_to: 0)
    |> cast_embed(:custos_fixos_mensais, required: true)
  end
end
