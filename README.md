API de Análise de Investimento Imobiliário
==========================================

Descrição
---------
Esta API permite avaliar a viabilidade financeira de investimentos imobiliários, considerando valor do imóvel, entrada, financiamento, aluguel esperado, custos fixos e valorização anual estimada. Destinada a analistas financeiros, corretores ou sistemas de gestão de investimentos.

Requisitos
----------
- Elixir 
- Phoenix 
- Postman ou outro cliente HTTP para testes

Instalação e Execução
---------------------
1. Após clonar o projeto, instale e configure as dependências:

No termial, digite:

   mix setup

2. Iniciar servidor Phoenix:

No termial, digite:

   mix phx.server

   Ou dentro do IEx (console interativo):

   iex -S mix phx.server

3. O servidor estará disponível em:

   http://localhost:4000

4. No postman, crie a seguinte requisição:

POST 
http://localhost:4000/api/analise-investimento

Content-Type: application/json

Input de exemplo:

{
  "valor_imovel": 500000,
  "entrada": 100000,
  "taxa_juros_anual": 8.0,
  "prazo_financiamento_meses": 240,
  "aluguel_mensal_esperado": 4500,
  "taxa_vacancia_anual": 5,
  "custos_fixos_mensais": {
    "condominio": 400,
    "iptu_mensal": 150,
    "seguro": 50,
    "manutencao_estimada": 100
  },
  "valorizacao_anual_estimada": 5
}

Exemplo de resposta esperada:

{
    "metricas": {
        "cap_rate": 8.58,
        "payback_anos": 36.35,
        "roi_5_anos": 51.9,
        "yield_bruto_anual": 10.8,
        "yield_liquido_anual": 8.58
    },
    "parecer": {
        "pontos_atencao": [],
        "Parcela > 30% do aluguel bruto",
        "recomendacao": "Investimento atrativo",
        "viabilidade": "ALTA"
    },
    "resumo": {
        "custo_total_fixo_mensal": 700.0,
        "fluxo_caixa_mensal": 229.24,
        "parcela_mensal": 3345.76,
        "receita_liquida_mensal": 3575.0,
        "valor_financiado": 400000
    }
}


Considerações
-------------
Com mais tempo disponível, seria possível aprofundar a análise dos cálculos financeiros subjacentes à API, 
incluindo validações detalhadas de fórmulas e simulações de diferentes parâmetros de investimento. 
Além disso, poderia ter desenvolvido um conjunto mais abrangente de cenários de teste, contemplando variações de entrada, condições extremas e casos de exceção,
aumentando a robustez, a confiabilidade e a previsibilidade dos resultados da análise de investimentos

