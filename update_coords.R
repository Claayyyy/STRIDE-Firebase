
# update_coords.R

library(dplyr)

# Read the new coordinates
coords <- read.csv("school_coordinates.csv", stringsAsFactors = FALSE)
coords <- coords %>% select(SchoolID, Latitude, Longitude)

# Function to update a dataset
update_file <- function(file_path) {
  message(paste("Processing:", file_path))
  
  if (!file.exists(file_path)) {
    message(paste("File not found:", file_path))
    return()
  }
  
  data <- read.csv(file_path, stringsAsFactors = FALSE, check.names = FALSE)
  
  # Ensure SchoolID is matching type (integer/numeric)
  data$SchoolID <- as.numeric(data$SchoolID)
  coords$SchoolID <- as.numeric(coords$SchoolID)
  
  # Join with new coordinates
  # We use a left join to keep all original rows
  # but first we need to handle existing Lat/Long columns to avoid duplication
  
  has_lat <- "Latitude" %in% names(data)
  has_long <- "Longitude" %in% names(data)
  
  if (has_lat && has_long) {
    message("Updating existing Latitude/Longitude columns...")
    
    # Simple approach: Loop through the 14 schools and update directly
    # This preserves the original dataframe structure perfectly
    
    for (i in 1:nrow(coords)) {
      sid <- coords$SchoolID[i]
      lat <- coords$Latitude[i]
      long <- coords$Longitude[i]
      
      if (!is.na(lat) && !is.na(long)) {
        # Update matching rows
        idx <- which(data$SchoolID == sid)
        if (length(idx) > 0) {
          data$Latitude[idx] <- lat
          data$Longitude[idx] <- long
        }
      }
    }
    
  } else {
    message("Adding Latitude/Longitude columns...")
    # Join to add them
    data <- left_join(data, coords, by = "SchoolID")
    
    # If using left_join, columns might be named Latitude.y if Latitude.x existed (but we checked)
    # Since we checked !has_lat, they should be clean Latitude/Longitude
  }
  
  # Write back to file
  write.csv(data, file_path, row.names = FALSE, na = "")
  message(paste("Updated:", file_path))
}

# List of files to update
files_to_update <- c("School-Unique-48k.csv", "EFD-DataBuilder-2025.csv", "uni123.csv")

for (f in files_to_update) {
  update_file(f)
}
