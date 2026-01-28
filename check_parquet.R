library(arrow)
library(dplyr)

# Check what's in the parquet file
uni45k <- read_parquet("School-Unique-v2.parquet")

cat("=== School-Unique-v2.parquet ===\n")
cat("Column names containing 'Lat' or 'Long':\n")
lat_long_cols <- names(uni45k)[grepl("Lat|Long", names(uni45k), ignore.case = TRUE)]
print(lat_long_cols)

if (length(lat_long_cols) > 0) {
  cat("\nFirst 10 rows with coordinates:\n")
  coord_data <- uni45k[, c("SchoolID", lat_long_cols)]
  print(head(coord_data[complete.cases(coord_data), ], 10))
  
  cat("\nNumber of non-NA coordinate rows:", sum(complete.cases(coord_data)), "\n")
}
