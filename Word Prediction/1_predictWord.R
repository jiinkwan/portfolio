load("uni_words.Rda")
load("bi_words.Rda")
load("tri_words.Rda")
load("quad_words.Rda")
#library(tm)
# function to return highly probable previous word given three successive words
quadWords <- function(w1, w2, w3,n = 5) {
  pwords <- quad_words[.(w1, w2, w3)][order(-Prob)]
  if (any(is.na(pwords)))
    return(triWords(w2, w3, n))
  if (nrow(pwords) > n)
    return(pwords[1:n, word_4])
  count <- nrow(pwords)
  twords <- triWords(w3, n)[1:(n - count)]
  return(c(pwords[, word_4], twords))
}

# function to return highly probable previous word given two successive words
triWords <- function(w1, w2, n = 5) {
  pwords <- tri_words[.(w1, w2)][order(-Prob)]
  if (any(is.na(pwords)))
    return(biWords(w2, n))
  if (nrow(pwords) > n)
    return(pwords[1:n, word_3])
  count <- nrow(pwords)
  bwords <- biWords(w2, n)[1:(n - count)]
  return(c(pwords[, word_3], bwords))
}

# function to return highly probable previous word given a word
biWords <- function(w1, n = 5) {
  pwords <- bi_words[w1][order(-Prob)]
  if (any(is.na(pwords)))
    return(uniWords(n))
  if (nrow(pwords) > n)
    return(pwords[1:n, word_2])
  count <- nrow(pwords)
  unWords <- uniWords(n)[1:(n - count)]
  return(c(pwords[, word_2], unWords))
}

# function to return random words from unigrams
uniWords <- function(n = 5) {  
  return(sample(uni_words[, word_1], size = n))
}

# The prediction app
getWords <- function(str){
  require(quanteda)
  if(str == ""){
    words <- "the"
    return(words)}
  else
    tokens <- tokens(x = char_tolower(str))
    tokens <- char_wordstem(rev(rev(tokens[[1]])[1:3]), language = "english")
    
    #words <- triWords(tokens[1], tokens[2], 5)
    words <- quadWords(tokens[1], tokens[2], tokens[3], 5)
    chain_1 <- paste(tokens[1], tokens[2], tokens[3], words[1], sep = " ")
    
    #print(words[1])
    return(words)
    
}