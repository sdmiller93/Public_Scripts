library(tidyverse)
library(ggupset)

# This script is intended to prep differential expression output tables with 
# log2fold change values for input into ggUpSet. In this example, I've 
# included 3 differential expression tables that I want to prep for a single 
# UpSet plot.

# Input: 3 differential expression tables
# Output: upset plot, png format, to Desktop location

# NOTE- if you may need to edit the path on line 145 to save image elsewhere

################################################################################
## VARIABLES - ENTER INFORMATION HERE
################################################################################
## TODO accept a config file set names, paths and parse information through 
# script to produce figures with minimal input.


## ENTER PATHS FOR YOUR DIFFERENTIAL EXPRESSION TABLES
de1_path <- c("/path/to/differentialexpressionoutput1.txt")
de2_path <- c("/path/to/differentialexpressionoutput2.txt")
de3_path <- c("/path/to/differentialexpressionoutput3.txt")

## ENTER THE SET NAMES FOR EACH DIFFERENTIAL EXPRESSION DATAFRAME
de1_setname <- c("set1_versus_set2")
de2_setname <- c("set1_versus_set3")
de3_setname <- c("set2_versus_set3")

## ENTER DESIRED SIGNIFICANT log2fold change VALUE, default = 2
sig_logFC <- 2

## ENTER NAME OF LOGFC COLUMN - default = logFC
logfc_col <- c("logFC")

## ENTER NAME OF TRANSCRIPT COLUMN - default = GeneID
transcript_col <- c("GeneID")


################################################################################
################################################################################
## WORKHORSE - SHOULD NOT NEED TO EDIT BELOW HERE
################################################################################
################################################################################


################################################################################
## read in data
################################################################################
## read in differential expression tables
de1 <- read.delim(file = de1_path, as.is = TRUE, header = TRUE)

de2 <- read.delim(file = de2_path, as.is = TRUE, header = TRUE) 

de3 <- read.delim(file = de3_path, as.is = TRUE, header = TRUE) 


################################################################################
## FUNCTIONS
################################################################################
## Function to set col names, assign up/down/flat annotations
clean_de_table <- function(de_table, de_set_name){
  
  df <- de_table %>% 
    ## add identifier column of dataset
    mutate(set_name = de_set_name) %>% 
    ## so later code works, rename 2 columns of interest from above
    rename(logFC := !!logfc_col, 
           GeneID := !!transcript_col) %>% 
    ## add column for up, down, flat notations --
    ## when greater than your sig_logFC value = up
    ## when less than negative (-) your sig_logFC value = down
    ## when between your +sig_logFC and -sig_logFC value = flat
    mutate(change = case_when(logFC > sig_logFC ~ "up", 
                              logFC < -sig_logFC ~ "down", 
                              between(logFC, -sig_logFC, sig_logFC) ~ "flat")) %>% 
    ## create a col with concatenated set name and change assignment
    unite("col", c(set_name, change)) %>% 
    ## reduce columns
    select(GeneID, col) %>%
    ## collect unique combinations of geneID and col
    distinct(GeneID, col) %>%
    ## create column where everything is 1
    mutate(val = 1) %>%
    ## pivot to classify where col(assignment) is 1 and rest are 0
    pivot_wider(names_from = col, values_from = "val", values_fill = 0)
  
  return(df)
}


################################################################################
## create annotated dataframes
################################################################################
## run functions on de tables
de1_annotated <- clean_de_table(de1, de1_setname)
de2_annotated <- clean_de_table(de2, de2_setname)
de3_annotated <- clean_de_table(de3, de3_setname)

## TODO add unit test to make sure each row only has a single 1 per row
## TODO add unit test to make sure nrows match initial nrows of df



################################################################################
## CREATE SINGULAR DATA FRAME
################################################################################
## join data frames so that there is one df with unique GeneIDs + annotations
de_tables <- de1_annotated %>% 
  left_join(de2_annotated, by = "GeneID") %>% 
  left_join(de3_annotated, by = "GeneID")

## TODO add unit test to make nrows of tables = nrow of this df and concatenated
## sum of cols



################################################################################
## TIDY FOR PLOT
################################################################################
## get list of colnames for use in pivot below, based upon set names
colnames <- as.list(colnames(de_tables))
## remove the first col name which is just GeneID
colnames <- colnames[-1]

## get long df 
tidy_de_tables <- de_tables %>%
  pivot_longer(., 
               cols = as.character(colnames),
               names_to = "classification", 
               values_to = "value") %>% 
  ## only keep rows where classification = 1
  filter(value == 1) %>% 
  group_by(GeneID) %>%
  summarize(classifications = list(classification))




################################################################################
## PLOT & SAVE
################################################################################
# 1. Open a png file
png(file="~/Desktop/upset.png",  width=1200, height=800)
# 2. Create a plot
tidy_de_tables %>%
  ggplot(aes(x = classifications)) +
  geom_bar() +
  scale_x_upset()

# Close the pdf file
dev.off() 

