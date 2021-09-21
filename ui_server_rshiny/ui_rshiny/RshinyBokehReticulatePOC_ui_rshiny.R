RshinyBokehReticulatePOC_ui_rshiny<-
  fluidPage(
    tags$head(
      HTML(
        '
      <script src="https://cdnjs.cloudflare.com/ajax/libs/bokeh/2.3.3/bokeh.min.js" crossorigin="anonymous"></script>
      '
      ),
      useShinyjs(),

      HTML(
        "
                  <script>
                   var api_bokehinlinejs_ajax_url = null;
                   $(document).on('change', '#api_bokehinlinejs_ajax_url', function(event) {
                      api_bokehinlinejs_ajax_url = $(this).val();
                      Shiny.onInputChange('api_bokehinlinejs_ajax_url_loaded', api_bokehinlinejs_ajax_url);
                   });
                  </script>
                  "
      ),
      
      HTML(
        "
                  <script>
                   var api_datasinus_ajax_url = null;
                   $(document).on('change', '#api_datasinus_ajax_url', function(event) {
                      api_datasinus_ajax_url = $(this).val();
                      Shiny.onInputChange('api_datasinus_ajax_url_loaded', api_datasinus_ajax_url);
                   });
                  </script>
                  "
      ),
      shinyjs::extendShinyjs(
        text = "
                  shinyjs.bokeh_graph1 = function() { 
                      var req = new XMLHttpRequest();
                      req.overrideMimeType('application/json');
                      console.log(api_bokehinlinejs_ajax_url);
                      req.open('POST', api_bokehinlinejs_ajax_url, true)
                      req.onload  = function() {
                          var result = JSON.parse(req.responseText);
                          console.log(result);
                          var temp1 = result.gr;
                          document.getElementById('bokeh_ch1').innerHTML = temp1.div.p1;
                          document.getElementById('bokeh_ch2').innerHTML = temp1.div.p2;
                          eval(temp1.script);
                      };
                      req.send()
                  }
              ",
        functions = c("bokeh_graph1")
        
      ),
      tags$input(id="api_datasinus_ajax_url", type="text", value="", class="shiny-bound-input", style="display:noneXXX;"),      
      tags$input(id="api_bokehinlinejs_ajax_url", type="text", value="", class="shiny-bound-input", style="display:noneXX;"),      

    ),
    splitLayout(
      div(id="bokeh_ch1"),
      div(),
      div(id="bokeh_ch2"),
      cellWidths =c("25%","50%","25%")                                       
    )
  )