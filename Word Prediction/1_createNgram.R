bi_gram <- tokens_ngrams(stemed_words, n = 2)
tri_gram <- tokens_ngrams(stemed_words, n = 3)
quad_gram <- tokens_ngrams(stemed_words, n = 4)

uni_DFM <- dfm(stemed_words)
bi_DFM <- dfm(bi_gram)
tri_DFM <- dfm(tri_gram)
quad_DFM <- dfm(quad_gram)

# trimpming
quad_DFM <- dfm_trim(quad_DFM, 3)

# Create named vectors with counts of words 
sums_U <- colSums(uni_DFM)
sums_B <- colSums(bi_DFM)
sums_T <- colSums(tri_DFM)
sums_Q <- colSums(quad_DFM)

# Create data tables with individual words as columns
uni_words <- data.table(word_1 = names(sums_U), count = sums_U)

bi_words <- data.table(
  word_1 = sapply(strsplit(names(sums_B), "_", fixed = TRUE), '[[', 1),
  word_2 = sapply(strsplit(names(sums_B), "_", fixed = TRUE), '[[', 2),
  count = sums_B)

tri_words <- data.table(
  word_1 = sapply(strsplit(names(sums_T), "_", fixed = TRUE), '[[', 1),
  word_2 = sapply(strsplit(names(sums_T), "_", fixed = TRUE), '[[', 2),
  word_3 = sapply(strsplit(names(sums_T), "_", fixed = TRUE), '[[', 3),
  count = sums_T)

quad_words <- data.table(
  word_1 = sapply(strsplit(names(sums_Q), "_", fixed = TRUE), '[[', 1),
  word_2 = sapply(strsplit(names(sums_Q), "_", fixed = TRUE), '[[', 2),
  word_3 = sapply(strsplit(names(sums_Q), "_", fixed = TRUE), '[[', 3),
  word_4 = sapply(strsplit(names(sums_Q), "_", fixed = TRUE), '[[', 4),
  count = sums_T)


graph.data <- uni_words[order(uni_words$count, decreasing = T), ]
graph.data <- graph.data[1:20, ]
graph.data$word_1 <- factor(graph.data$word_1, levels = graph.data$word_1)

ggplot(data=graph.data, aes(x=word_1, y=count)) + geom_bar(stat="identity") +
  theme(axis.text.x = element_text(angle = 40, hjust = 1))

graph.data <- bi_words[order(bi_words$count, decreasing = T), ]
graph.data <- graph.data[1:20, ]
graph.data$word <- paste(graph.data$word_1, graph.data$word_2)
graph.data$word <- factor(graph.data$word, levels = graph.data$word)

ggplot(data=graph.data, aes(x=word, y=count)) + geom_bar(stat="identity")

graph.data <- tri_words[order(tri_words$count, decreasing = T), ]
graph.data <- graph.data[1:20, ]
graph.data$word <- paste(graph.data$word_1, graph.data$word_2, graph.data$word_3)
graph.data$word <- factor(graph.data$word, levels = graph.data$word)

ggplot(data=graph.data, aes(x=word, y=count)) + geom_bar(stat="identity") + 
  theme(axis.text.x = element_text(angle = 40, hjust = 1))

graph.data <- quad_words[order(quad_words$count, decreasing = T), ]
graph.data <- graph.data[1:20, ]
graph.data$word <- paste(graph.data$word_1, graph.data$word_2, graph.data$word_3, graph.data$word4)
graph.data$word <- factor(graph.data$word, levels = graph.data$word)

ggplot(data=graph.data, aes(x=word, y=count)) + geom_bar(stat="identity") + 
  theme(axis.text.x = element_text(angle = 40, hjust = 1))

# set keys

setkey(uni_words, word_1)
setkey(bi_words, word_1, word_2)
setkey(tri_words, word_1, word_2, word_3)
setkey(quad_words, word_1, word_2, word_3, word_4)