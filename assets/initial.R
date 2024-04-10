# Coluna a ser predita: "Sleep.Disorder"

df <- read.csv("assets/Sleep_health_and_lifestyle_dataset.csv") %>%
    na.omit() %>%
    mutate(Sleep.Disorder = ifelse(
                    Sleep.Disorder %in% c("Sleep Apnea", "Insomnia"),
                    "Positive",
                    Sleep.Disorder
                )
            )

# Usar o mutate se seu modelo só suportar classificação binária (duas classes)

# Para receitas, utilizar um padrão como o seguinte:

rec <- recipe(Sleep.Disorder ~ ., df) %>%
    # Remover a Coluna Id que não vai nos ajudar
    step_rm(Person.ID) %>%
    # Converte as variáveis nominais para dummy variables
    # exceto pela saída, que não queremos converter.
    step_dummy(all_nominal(), -all_outcomes()) %>%
    # Vamos agora centrar e escalonar nossas
    # variáveis
    step_center(all_predictors()) %>%
    step_scale(all_predictors())

# Basicamente, lembrar de tirar a coluna ID (que nao ajuda nas previsoes),
# converter variaveis categoricas para dummy e
# centrar e escalonar os dados para poder aplicar os modelos

# Dividir dados em treino e teste
set.seed(42)
ind <- sample(2, 374, replace = TRUE, prob = c(0.7,0.3))
treino <- df[ind == 1,]
teste  <- df[ind == 2,]

# Vamos todos usar a mesma seed para dividir os dados entre treino e teste, para que a comparação entre algoritmos seja mais justa
