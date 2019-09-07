load("uni_words.Rda")
load("bi_words.Rda")
load("tri_words.Rda")
load("quad_words.Rda")

# Kneser-Kney Smoothing

discount_value <- 0.75

######## Finding Bi-Gram Probability #################

# Finding number of bi-gram words
numOfBiGrams <- nrow(bi_words[by = .(word_1, word_2)])

# Dividing number of times word 2 occurs as second part of bigram, by total number of bigrams.  
# ( Finding probability for a word given the number of times it was second word of a bigram)
ckn <- bi_words[, .(Prob = ((.N) / numOfBiGrams)), by = word_2]
setkey(ckn, word_2)

# Assigning the probabilities as second word of bigram, to unigrams
uni_words[, Prob := ckn[word_1, Prob]]
uni_words <- uni_words[!is.na(uni_words$Prob)]

# Finding number of times word 1 occurred as word 1 of bi-grams
n1wi <- bi_words[, .(N = .N), by = word_1]
setkey(n1wi, word_1)

# Assigning total times word 1 occured to bigram cn1
bi_words[, Cn1 := uni_words[word_1, count]]

# Kneser Kney Algorithm
bi_words[, Prob := ((count - discount_value) / Cn1 + discount_value / Cn1 * n1wi[word_1, N] * uni_words[word_2, Prob])]

######## End of Finding Bi-Gram Probability #################

######## Finding Tri-Gram Probability #################

# Finding count of word1-word2 combination in bigram 
tri_words[, Cn2 := bi_words[.(word_1, word_2), count]]

# Finding count of word1-word2 combination in trigram
n1w12 <- tri_words[, .N, by = .(word_1, word_2)]
setkey(n1w12, word_1, word_2)

# Kneser Kney Algorithm
tri_words[, Prob := (count - discount_value) / Cn2 + discount_value / Cn2 * n1w12[.(word_1, word_2), N] *
            bi_words[.(word_1, word_2), Prob]]

######## End of Finding Quad-Gram Probability #################

# Finding count of word1-word2 combination in bigram 
quad_words[, Cn3 := tri_words[.(word_1, word_2, word_3), count]]

# Finding count of word1-word2 combination in trigram
n1w123 <- quad_words[, .N, by = .(word_1, word_2, word_3)]
setkey(n1w123, word_1, word_2, word_3)

# Kneser Kney Algorithm
quad_words[, Prob := (count - discount_value) / Cn3 + discount_value / Cn3 * n1w123[.(word_1, word_2, word_3), N] *
            tri_words[.(word_1, word_2, word_3), Prob]]

######## End of Finding Quad-Gram Probability #################

save(file = "uni_words.Rda",uni_words)
save(file = "bi_words.Rda",bi_words)
save(file = "tri_words.Rda",tri_words)
save(file = "quad_words.Rda",quad_words)
