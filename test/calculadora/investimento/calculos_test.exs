defmodule Calculadora.Investimento.CalculosTest do
  use ExUnit.Case, async: true

  alias Calculadora.Investimento
  alias Calculadora.Investimento.CustosFixos
  alias Calculadora.Investimento.Calculos

  defp investimento_base(attrs \\ %{}) do
    %Investimento{
      valor_imovel: 500_000.0,
      entrada: 100_000.0,
      taxa_juros_anual: 6.0,
      prazo_financiamento_meses: 240,
      aluguel_mensal_esperado: 3000.0,
      taxa_vacancia_anual: 5.0,
      valorizacao_anual_estimada: 3.0,
      custos_fixos_mensais: %CustosFixos{
        condominio: 400.0,
        iptu_mensal: 200.0,
        seguro: 150.0,
        manutencao_estimada: 250.0
      }
    }
    # permite sobrescrever campos
    |> Map.merge(attrs)
  end

  test "calcula métricas básicas sem erros" do
    investimento = investimento_base()
    resultado = Calculos.analisar(investimento)

    assert is_float(resultado.metricas.yield_liquido_anual)
    assert is_float(resultado.metricas.cap_rate)
    assert is_float(resultado.metricas.yield_bruto_anual)
    assert is_float(resultado.metricas.roi_5_anos)
  end

  test "retorna viabilidade ALTA quando yield líquido >6% e fluxo positivo" do
    investimento = investimento_base(%{aluguel_mensal_esperado: 5000.0})
    resultado = Calculos.analisar(investimento)

    assert resultado.parecer.viabilidade == "ALTA"
  end

  test "retorna viabilidade BAIXA quando yield líquido <4%" do
    investimento = investimento_base(%{aluguel_mensal_esperado: 1000.0})
    resultado = Calculos.analisar(investimento)

    assert resultado.parecer.viabilidade == "BAIXA"
  end

  test "detecta pontos de atenção corretamente" do
    investimento =
      investimento_base(%{
        aluguel_mensal_esperado: 2000.0,
        taxa_vacancia_anual: 15.0,
        custos_fixos_mensais: %CustosFixos{
          condominio: 1000.0,
          iptu_mensal: 500.0,
          seguro: 200.0,
          manutencao_estimada: 500.0
        }
      })

    resultado = Calculos.analisar(investimento)

    assert "Taxa de vacância > 10%" in resultado.parecer.pontos_atencao
    assert "Custos fixos > 40% do aluguel" in resultado.parecer.pontos_atencao
  end
end
