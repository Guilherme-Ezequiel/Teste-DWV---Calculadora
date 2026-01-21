defmodule Calculadora.Investimento.Calculos do
  alias Calculadora.Investimento

  def analisar(%Investimento{} = inv) do
    # --- Extrair custos fixos ---
    custo_fixos_totais =
      inv.custos_fixos_mensais
      |> Map.from_struct()
      |> Map.values()
      |> Enum.map(&(&1 || 0))
      |> Enum.sum()

    # --- Valor financiado e parcelas (Price) ---
    valor_financiado = inv.valor_imovel - inv.entrada
    taxa_mensal = inv.taxa_juros_anual / 100 / 12
    n = inv.prazo_financiamento_meses

    parcela_mensal =
      if taxa_mensal > 0 do
        valor_financiado * (taxa_mensal * :math.pow(1 + taxa_mensal, n)) /
          (:math.pow(1 + taxa_mensal, n) - 1)
      else
        valor_financiado / n
      end

    # --- Receita líquida mensal considerando vacância ---
    receita_liquida_mensal =
      inv.aluguel_mensal_esperado * (1 - inv.taxa_vacancia_anual / 100) - custo_fixos_totais

    # --- Fluxo de caixa mensal ---
    fluxo_caixa_mensal = receita_liquida_mensal - parcela_mensal

    # --- Métricas anuais ---
    receita_liquida_anual = receita_liquida_mensal * 12
    yield_bruto_anual = inv.aluguel_mensal_esperado * 12 / inv.valor_imovel * 100
    yield_liquido_anual = receita_liquida_anual / inv.valor_imovel * 100
    cap_rate = receita_liquida_anual / inv.valor_imovel * 100

    # --- ROI 5 anos ---
    fluxo_caixa_acumulado_5_anos = fluxo_caixa_mensal * 12 * 5

    valorizacao_total =
      inv.valor_imovel * (:math.pow(1 + inv.valorizacao_anual_estimada / 100, 5) - 1)

    roi_5_anos =
      (fluxo_caixa_acumulado_5_anos + valorizacao_total - inv.entrada) / inv.entrada * 100

    # --- Payback ---
    payback_anos =
      if fluxo_caixa_mensal > 0 do
        inv.entrada / (fluxo_caixa_mensal * 12)
      else
        :infinity
      end

    # --- Viabilidade ---
    viabilidade =
      cond do
        yield_liquido_anual > 6 and fluxo_caixa_mensal > 0 ->
          "ALTA"

        (yield_liquido_anual >= 4 and yield_liquido_anual <= 6) or
            (fluxo_caixa_mensal >= -500 and fluxo_caixa_mensal <= 0) ->
          "MEDIA"

        true ->
          "BAIXA"
      end

    # --- Pontos de atenção ---
    pontos_atencao = []

    pontos_atencao =
      if inv.taxa_vacancia_anual > 10,
        do: ["Taxa de vacância > 10%"] ++ pontos_atencao,
        else: pontos_atencao

    pontos_atencao =
      if parcela_mensal > inv.aluguel_mensal_esperado * 0.3,
        do: ["Parcela > 30% do aluguel bruto"] ++ pontos_atencao,
        else: pontos_atencao

    pontos_atencao =
      if custo_fixos_totais > inv.aluguel_mensal_esperado * 0.4,
        do: ["Custos fixos > 40% do aluguel"] ++ pontos_atencao,
        else: pontos_atencao

    pontos_atencao =
      if cap_rate < 5, do: ["Cap rate < 5%"] ++ pontos_atencao, else: pontos_atencao

    # --- Recomendação baseada em viabilidade ---
    recomendacao =
      case viabilidade do
        "ALTA" -> "Investimento atrativo"
        "MEDIA" -> "Analisar detalhes do imóvel e mercado"
        "BAIXA" -> "Risco elevado, considerar alternativas"
      end

    # --- Montar JSON final ---
    %{
      resumo: %{
        valor_financiado: round(valor_financiado),
        parcela_mensal: Float.round(parcela_mensal, 2),
        custo_total_fixo_mensal: Float.round(custo_fixos_totais, 2),
        receita_liquida_mensal: Float.round(receita_liquida_mensal, 2),
        fluxo_caixa_mensal: Float.round(fluxo_caixa_mensal, 2)
      },
      metricas: %{
        yield_bruto_anual: Float.round(yield_bruto_anual, 2),
        yield_liquido_anual: Float.round(yield_liquido_anual, 2),
        cap_rate: Float.round(cap_rate, 2),
        payback_anos:
          if(payback_anos == :infinity, do: "não recuperável", else: Float.round(payback_anos, 2)),
        roi_5_anos: Float.round(roi_5_anos, 2)
      },
      parecer: %{
        viabilidade: viabilidade,
        pontos_atencao: pontos_atencao,
        recomendacao: recomendacao
      }
    }
  end
end
