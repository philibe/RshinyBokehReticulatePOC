options(encoding = "UTF-8")
     
library(shiny)

# thank you for rbokeh but it seems on stand by and old:
# library(rbokeh) 
#
# thank you for shiny.router but it seems on stand by and old:
# library(shiny.router)
# 
library(shinyjs) 
library(tidyverse)
library(RJSONIO)   
library(rjson)
library(reticulate)   
library(gtools) 
    

options(error = NULL)    

if (interactive()) {
  # in RStudio
  options(  error = function() {.rs.recordTraceback(TRUE,minDepth=1,.rs.enqueueError)})
}else {
  # in Shiny-Server
  options(  error = function() {traceback() })
}
 

reticulate::use_condaenv("rshiny_bokeh_reticulate", required = TRUE) 

 
shinyServer(function(input, output, session) {
  
   
  react <- reactiveValues(  
    var_session_param =list(x = as.double(0), y = as.double(0), HistoryArray = list(list(x = NA_real_, y = NA_real_)))
  )    
  

  source ("ui_server_rshiny/server_rshiny/RshinyBokehReticulatePOC_server_rshiny.R", local = TRUE)
})
