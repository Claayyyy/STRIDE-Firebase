# ui_parts/03_loading_overlay.R

ui_loading <- tags$div(
  id = "loading-overlay",
  style = "
   display: none;
   position: fixed;
   top: 0; left: 0;
   width: 100%; height: 100%;
   background-color: #ffffff;
   z-index: 99999;
   text-align: center;
  ",
  tags$div(
    style = "position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);
             color: black; font-size: 1.3em;",
    tags$img(src = "LOAD.gif", height = "200px"),  # 👈 replace with your GIF or logo
  )
)