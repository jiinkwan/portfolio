library(tm)
library(quanteda)
# Loading Data

con1 <- file("./data/final/en_US/en_US.twitter.txt", "r")
con2 <- file("./data/final/en_US/en_US.blogs.txt", "r")
con3 <- file("./data/final/en_US/en_US.news.txt", "r")
US_Twitter <- readLines(con1)
US_Blogs <- readLines(con2)
US_News <- readLines(con3)

#Sampling

sampleHolderTwitter <- sample(length(US_Twitter), length(US_Twitter) * 0.1)
sampleHolderBlog <- sample(length(US_Blogs), length(US_Blogs) * 0.1)
sampleHolderNews <- sample(length(US_News), length(US_News) * 0.1)

US_Twitter_Sample <- US_Twitter[sampleHolderTwitter]
US_Blogs_Sample <- US_Blogs[sampleHolderBlog]
US_News_Sample <- US_News[sampleHolderNews]

# Make a corpus
master_vector <- c(US_Twitter_Sample, US_Blogs_Sample, US_News_Sample)
corp <- corpus(master_vector)