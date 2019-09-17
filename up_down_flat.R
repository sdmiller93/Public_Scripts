library(dplyr)

# READ IN DIFF EXP DATAFRAME
de <- read.delim(file = "/path/to/file.tsv", as.is = TRUE, sep = "\t", header = TRUE)

# Make new columns in your de table for the binary evals to go
de$comp1_up <- NA
de$comp1_down <- NA
de$comp1_flat <- NA

de$comp2_up <- NA
de$comp2_down <- NA
de$comp2_flat <- NA

de$comp3_up <- NA
de$comp3_down <- NA
de$comp3_flat <- NA

# comp1 is a pairwise comparison between two factors (ie. muscle 1 vs muscle 2) in which the logFC can either be up, down, or flat

for (i in 1:nrow(de)){ # this is for the comp1 set

	if (de$comp1_logFC[i] >= 2){ # where de$comp1_logFC holds your logFC value for the first vs second factor & 2 is my logFC significance threshold
		de$comp1_up[i] <- "1"
		de$comp1_down[i] <- "0"
		de$comp1_flat[i] <- "0"
	} else if (de$comp1_logFC[i] <= -2){
		de$comp1_up[i] <- "0"
		de$comp1_down[i] <- "1"
		de$comp1_flat[i] <- "0"
	} else if (between(de$comp1_logFC[i], -2, 2)){
		de$comp1_up[i] <- "0"
		de$comp1_down[i] <- "0"
		de$comp1_flat[i] <- "1"
	} else {
		warning(paste("problem with row:",i))
	}
	
	
}

for (i in 1:nrow(de)){ # this is for the comp2 set

	if (de$comp2_logFC[i] >= 2){
		de$comp2_up[i] <- "1"
		de$comp2_down[i] <- "0"
		de$comp2_flat[i] <- "0"
	} else if (de$comp2_logFC[i] <= -2){
		de$comp2_up[i] <- "0"
		de$comp2_down[i] <- "1"
		de$comp2_flat[i] <- "0"
	} else if (between(de$comp2_logFC[i], -2, 2)){
		de$comp2_up[i] <- "0"
		de$comp2_down[i] <- "0"
		de$comp2_flat[i] <- "1"
	} else {
		warning(paste("problem with row:",i))
	}
	
	
}

for (i in 1:nrow(de)){ # this is for the comp3 set

	if (de$comp3_logFC[i] >= 2){
		de$comp3_up[i] <- "1"
		de$comp3_down[i] <- "0"
		de$comp3_flat[i] <- "0"
	} else if (de$comp3_logFC[i] <= -2){
		de$comp3_up[i] <- "0"
		de$comp3_down[i] <- "1"
		de$comp3_flat[i] <- "0"
	} else if (between(de$comp3_logFC[i], -2, 2)){
		de$comp3_up[i] <- "0"
		de$comp3_down[i] <- "0"
		de$comp3_flat[i] <- "1"
	} else {
		warning(paste("problem with row:",i))
	}
	
	
}
write.table(de, file = "~/Desktop/de_up_down.tsv", append = TRUE, sep = "\t", col.names = TRUE, row.names = FALSE, quote = FALSE)
