options(encoding = "UTF-8")

library(shiny)
library(shinyjs)

source ("ui_server_rshiny/ui_rshiny/RshinyBokehReticulatePOC_ui_rshiny.R", local = TRUE)


shinyUI(
  RshinyBokehReticulatePOC_ui_rshiny
  
)
