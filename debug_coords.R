# Debug script to check if Lat/Long are in the uni dataframe
library(dplyr)

uni48k <- read.csv("School-Unique-48k.csv")
cat("=== School-Unique-48k.csv ===\n")
cat("Column names containing 'Lat' or 'Long':\n")
print(names(uni48k)[grepl("Lat|Long", names(uni48k), ignore.case = TRUE)])
cat("\nFirst 5 rows of Lat/Long:\n")
print(head(uni48k[, c("SchoolID", "Lat", "Long")], 5))
cat("\nData types:\n")
cat("Lat:", class(uni48k$Lat), "\n")
cat("Long:", class(uni48k$Long), "\n")
cat("\nNumber of non-NA Lat values:", sum(!is.na(uni48k$Lat)), "\n")
cat("Number of non-NA Long values:", sum(!is.na(uni48k$Long)), "\n")
