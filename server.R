options(encoding = "UTF-8")

library(shiny)
 
# thank you for rbokeh but it seems on stand by and old
# library(rbokeh) 
#
# thank you for shiny.router but it seems on stand by and old
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
  # Dans RStudio
  options(  error = function() {.rs.recordTraceback(TRUE,minDepth=1,.rs.enqueueError)})
}else {
  # Dans Shiny-Server
  options(  error = function() {traceback() })
}
     
 
# sudo su shiny           
# cd
# curl https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh -o Anaconda3-2021.05-Linux-x86_64.sh
# see: https://docs.anaconda.com/anaconda/install/linux/
# bash Anaconda3-2021.05-Linux-x86_64.sh
# yes
# yes
# anaconda3/bin/conda create --name rshiny_bokeh_reticulate
# bash in your user:
# anaconda3/bin/conda activate rshiny_bokeh_reticulate         
# sh in shiny user: 
# . anaconda3/etc/profile.d/conda.sh
# conda activate rshiny_bokeh_reticulate
# conda install -c anaconda bokeh
reticulate::use_condaenv("rshiny_bokeh_reticulate", required = TRUE) 
      
              
shinyServer(function(input, output, session) {

  session$userData$var_session_param =list(x = as.double(0), y = as.double(0), HistoryArray = list(list(x = NA_real_, y = NA_real_)))

 
  #print(session)
  source ("ui_server_rshiny/server_rshiny/RshinyBokehReticulatePOC_server_rshiny.R", local = TRUE)
})
