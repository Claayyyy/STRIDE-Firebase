# 99_others

output$StrideLogo <- renderImage({
  image_path <- normalizePath(file.path('www', 'STRIDE logo.png'))
  list(
    src = image_path,  # Path relative to the www directory
    contentType = "image/png",
    alt = "STRIDE logo",
    width = "100%",
    height = "auto"
    # You can also set width and height here, e.g., width = 400,
    # or control them in the imageOutput in the UI.
  )
}, deleteFile = FALSE)
# deleteFile = FALSE is important for pre-existing static files