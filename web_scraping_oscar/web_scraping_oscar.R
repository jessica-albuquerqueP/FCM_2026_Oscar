
# ==============================================
# ATIVIDADE - WEB SCRAPING
# OSCAR WINNING FILMS (2010-2015)
# ==============================================

# 1. Instalar os pacotes (apenas na primeira vez)
install.packages(c("jsonlite", "dplyr"))

# 2. Carregar os pacotes
library(jsonlite)
library(dplyr)

# 3. Endereco do site
url_base <- paste0(
  "https://www.scrapethissite.com/",
  "pages/ajax-javascript/"
)


# 4. Definir os seis anos
anos <- 2010:2015

# 5. Criar uma lista para guardar os resultados
lista_filmes <- vector("list", length(anos))

# 6. Extrair os dados de cada ano
for (i in seq_along(anos)) {
  
  ano <- anos[i]
  
  # Montar a URL da requisicao AJAX
  url <- paste0(
    url_base,
    "?ajax=true&year=", ano
  )
  
  # Ler os dados retornados em JSON
  dados <- fromJSON(url)
  
  # Guardar o resultado
  lista_filmes[[i]] <- dados
  
  cat("Ano coletado:", ano, "\n")
  
  # Pequena pausa entre requisicoes
  Sys.sleep(0.5)
}

# 7. Juntar os dados dos seis anos
oscar <- bind_rows(lista_filmes)

# 8. Organizar e traduzir as colunas
oscar <- oscar %>%
  transmute(
    Ano = year,
    Filme = title,
    Indicacoes = nominations,
    Premios = awards,
    Melhor_Filme = best_picture
  ) %>%
  arrange(Ano, Filme)

# 9. Visualizar a tabela
View(oscar)

# 10. Conferir a quantidade de filmes por ano
print(table(oscar$Ano))

# 11. Conferir o total de registros
cat("Total de filmes:", nrow(oscar), "\n")

# 12. Salvar a tabela em CSV
write.csv(
  oscar,
  "oscar_2010_2015.csv",
  row.names = FALSE,
  fileEncoding = "UTF-8"
)

cat("Arquivo CSV salvo com sucesso!\n")
