dados_modelo <- readRDS("dados_modelo.rds")

library(brms)

form_lp <- bf(
  ACERTOS_LP | trials(NU_TOTAL) ~ 0 + ETAPA + ETAPA:EP_fct + NSE_std + (1 | NM_REGIONAL / CD_ESCOLA)
)

modelo_lp <- brm(
  form_lp,
  data = dados_modelo,
  family = binomial(link = "logit"), 
  prior = c(
    prior(normal(0, 1.5), class = "b"), 
    prior(exponential(1), class = "sd")),
    iter = 2000, warmup = 1000,
  backend = 'cmdstanr',
  cores = 4, chains = 2, threads = threading(1), 
  stan_model_args = list(stanc_options = list("O1"))
)

saveRDS(modelo_lp, "modelo_lp_ajustado.rds")
