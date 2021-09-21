
api_datasinus <- function (var_session_param,operation) {
  if (gtools::invalid(var_session_param['x'])) {
    var_session_param=list()
    var_session_param['x']=0
  }
  if (gtools::invalid(var_session_param['y'])) {
    var_session_param['y']=0
  }
  
  if (gtools::invalid(var_session_param['HistoryArray'])) {
    var_session_param[['HistoryArray']] = list(list(x = 0, y = 0))
  }
  
  if (operation=='increment') {
    var_session_param['x'] = var_session_param[['x']] + 0.1
  }
  
  var_session_param['y'] = sin(var_session_param[['x']] )
  
  if (operation=='increment') {
    var_session_param[['HistoryArray']][
      length(var_session_param[['HistoryArray']])+1
    ]=list(
      list(
        x=var_session_param[['x']],
        y=var_session_param[['y']]
      )
    )
    # tail (x, n) last n elements
    var_session_param[['HistoryArray']]=tail(var_session_param[['HistoryArray']],10 )
    
    return  (
      var_session_param
    )
  }
  else{
    response_object=list()
    response_object[['status']]='success'
    
    # rev(x) reversing using list slicing
    response_object[['sinus']] = rev(var_session_param[['HistoryArray']])
    return (response_object)
  }
}

# to test in internet browser js console:
# var req = new XMLHttpRequest();
# req.overrideMimeType("application/json");
# 
# # # within rstudio in "open in internet browser" mode where YYYY is the web service part of the rstudio given by Rstudio
# req.open("POST","http://192.168.1.XXXX:8787/p/YYYY/"+api_datasinus_ajax_url+'&operation=increment',true)
# req.send()
# var jsonResponse = JSON.parse(req.responseText);
api_datasinus_ajax_url_react <- reactive({
  ajax_url=  session$registerDataObj(
    data= NA,
    name = "api_datasinus_ajax_url_name", # an arbitrary name for the AJAX request handler
    filter = function(data, req) {
      operationParam <- parseQueryString(req$operation)
      
      query <- parseQueryString(req$QUERY_STRING)
      operationQueryParam <- query$operation
      
      shiny:::httpResponse(
        200, "application/json",
        {
          response_object =list()
          
          session$userData$var_session_param <-api_datasinus(session$userData$var_session_param,operationQueryParam)
          
          if (operationQueryParam=='increment') {
            
            response_object =list(
              x=as.array( session$userData$var_session_param[['x']]),
              y=as.array(session$userData$var_session_param[['y']])
            )
            
          } else {
            response_object [['status']]='success'
            response_object [['sinus']]=session$userData$var_session_param[['HistoryArray']]                    
            
          }
          
          RJSONIO:::toJSON(response_object)
        }
      )
    }
  )
  
  # Correlated on the UI side with :  tags$input(id="api_datasinus_ajax_url", type="text", value="", class="shiny-bound-input", style="display:none;"),  
  session$sendInputMessage("api_datasinus_ajax_url", list(value=ajax_url))
  
  ajax_url
})





observeEvent(
  input$api_datasinus_ajax_url
  , {  
    api_datasinus_ajax_url_react()
    api_bokehinlinejs_ajax_url_react()
  } ,ignoreNULL = TRUE  ,once=TRUE
)   


# to test in internet browser js console:
# var req = new XMLHttpRequest();
# req.overrideMimeType("application/json");
# # without ProxyPass
# req.open("POST", "http://192.168.1.XXX:3838/apps/RshinyBokehReticulatePOC/"+api_bokehinlinejs_ajax_url, true)
# # # with ProxyPass
# req.open("POST", "http://192.168.1.XXX/shiny/apps/RshinyBokehReticulatePOC/"+api_bokehinlinejs_ajax_url, true)
# 
# # # within rstudio in "open in internet browser" mode where YYYY is the web service part of the rstudio given by Rstudio
# req.open("POST", "http://192.168.1.XXX:8787/p/YYYY/"+api_bokehinlinejs_ajax_url, true)
# req.send()
# var jsonResponse = JSON.parse(req.responseText);



api_bokehinlinejs_ajax_url_react <- reactive({
  
  req(api_datasinus_ajax_url_react())
  
  ajax_url=  session$registerDataObj(
    data= NA,
    name = "api_bokehinlinejs_ajax_url_name", # an arbitrary name for the AJAX request handler
    filter = function(data, req) {
      shiny:::httpResponse(
        200, "application/json",
        {
          reticulate::source_python(file.path(getwd(),"ui_server_rshiny","server_rshiny","RshinyBokehReticulatePOC.py"))
          
          api_bokehinlinejs_datas_js=py$api_bokehinlinejs(paste0(isolate(api_datasinus_ajax_url_react()),"&operation=increment" ) )
          RJSONIO:::toJSON(api_bokehinlinejs_datas_js)
        }
      )
    }
  )
  
  # Correlated on the UI side with :  tags$input(id="api_bokehinlinejs_ajax_url", type="text", value="", class="shiny-bound-input", style="display:none;"),  
  session$sendInputMessage("api_bokehinlinejs_ajax_url", list(value=ajax_url))
  
  
  ajax_url
})

All_Ajax_registerDataObj_filled<-reactive ({

  if(DescTools::Coalesce(input$api_bokehinlinejs_ajax_url_loaded,"") !="" & DescTools::Coalesce(input$api_datasinus_ajax_url_loaded,"") !="") {
    TRUE
  } else {
    NULL
  }
  
})





observeEvent(
  All_Ajax_registerDataObj_filled()
  , {
    
    
    
    print(input$api_bokehinlinejs_ajax_url)
    print(input$api_bokehinlinejs_ajax_url_loaded)
    shinyjs::js$bokeh_graph1()
    
    
  },ignoreNULL = TRUE  ,once=TRUE#, suspended = TRUE
)



