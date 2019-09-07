# the puncuations and numbers in the texts were removed as there is 
#no need to predict punctations or numbers
master_Tokens <- tokens(
  x = tolower(corp),
  remove_punct = TRUE,
  remove_twitter = TRUE,
  remove_numbers = TRUE,
  remove_hyphens = TRUE,
  remove_symbols = TRUE,
  remove_url = TRUE
)

stemed_words <- tokens_wordstem(master_Tokens, language = "english")
