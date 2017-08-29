# function to take a data.frame with bibliographic information, extract useful information, and make a DTM
make_DTM<-function(
	x, # an object of class data.frame
	stop.words
	# title=TRUE,
	# abstract=TRUE,
	# keyword=TRUE
	){

	# check format
	if(class(x)=="bibliography"){x<-make_reference_dataframe(x)}

	# collate data into a single vector
	text_vector<-apply(x[, c("title", "keywords", "abstract")], 1, function(a){
		if(all(is.na(a))){return("")
		}else{paste(a[which(is.na(a)==FALSE)], collapse=" ")}})

	# sort out stop words
	if(missing(stop.words)){stop.words<-tm::stopwords()
	}else{stop.words<-unique(c(tm::stopwords(), stop.words))}

	# convert to document term matrix
	corp <- Corpus(VectorSource(text_vector))
		corp <- tm_map(corp, content_transformer(tolower))
		corp <- tm_map(corp, removePunctuation)
		corp <- tm_map(corp, removeWords, stop.words)
		corp <- tm_map(corp, removeNumbers)
		stem.corp <- tm_map(corp, stemDocument)

	# create a lookup data.frame
	term<-unlist(lapply(as.list(corp), function(a){
		result<-strsplit(a, " ")[[1]]
		result <-gsub("^\\s+|\\s+$", "", result)
		return(result[which(result!=c(""))])
		}))
	word_freq<-as.data.frame(xtabs(~ term), stringsAsFactors=FALSE)
	word_freq$stem<-stemDocument(word_freq$term)

	# use control in DTM code to do remaining work
	dtm.control <- list(
		wordLengths = c(3, Inf),
		minDocFreq=5,
		weighting = weightTf)
	dtm<-DocumentTermMatrix(stem.corp , control= dtm.control)
	dtm<-removeSparseTerms(dtm, sparse= 0.99) # remove rare terms (cols)
	output<-as.matrix(dtm) # convert back to matrix
	rownames(output)<-x$ID

	# replace stemmed version with most common full word
	term_vec<-unlist(lapply(colnames(output), function(a, check){
		if(any(check$stem==a)){
			rows<-which(check$stem==a)	
			row<-rows[which.max(check$Freq[rows])]
			return(check$term[row])
		}else{return(a)}
		}, check=word_freq))
	colnames(output)<-term_vec

	return(output)
}