# Install Python, Anaconda, Bokeh

## Download Conda


Example of Conda installatio for Linux:

- https://docs.anaconda.com/anaconda/install/linux/

```sh
curl https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh -o Anaconda3-2021.05-Linux-x86_64.sh
```


## Install Conda for the current user 

Bash shell example for Linux

```bash
cd 
bash Anaconda3-2021.05-Linux-x86_64.sh
anaconda3/bin/conda create --name rshiny_bokeh_reticulate
conda activate rshiny_bokeh_reticulate
conda install -c anaconda bokeh
```

## Install Conda for Shiny Server (if applicable)

Sh shell example for Linux

```sh
sudo su shiny 
cd
/bin/sh Anaconda3-2021.05-Linux-x86_64.sh
. anaconda3/etc/profile.d/conda.sh
conda create --name rshiny_bokeh_reticulate
conda activate rshiny_bokeh_reticulate
conda install -c anaconda bokeh

```



# R Shiny side
## Install R Shiny
### Local Shiny (if no Shiny Server)

- https://www.rstudio.com/products/rstudio/download/

### Shiny Server 

- https://www.rstudio.com/products/shiny/download-server/
- https://www.rstudio.com/products/rstudio/download-server/

## Install packages

Install the packages corresponding to `library()` at the top of ui.R et server.R

- https://r-coder.com/install-r-packages/

# Debug Ajax in R Shiny
 
To debug  `session$registerDataObj()` (Ajax in R Shiny) in internet browser (F12)

## api_bokehinlinejs_ajax_url

### initialize
```javascript
var req = new XMLHttpRequest();
req.overrideMimeType("application/json");
```

### Post

####  without ProxyPass
`apps` is your PATH to Shiny Server Application
```javascript
req.open("POST", "http://192.168.1.XXX:3838/apps/RshinyBokehReticulatePOC/"+api_bokehinlinejs_ajax_url, true)
```
####  with ProxyPass
```javascript
req.open("POST", "http://192.168.1.XXX/shiny/apps/RshinyBokehReticulatePOC/"+api_bokehinlinejs_ajax_url, true)
```
####  within Rstudio Server
In   "open in internet browser" mode, where YYYY is the web service part of the url given by Rstudio
```javascript
req.open("POST", "http://192.168.1.XXX:8787/p/YYYY/"+api_bokehinlinejs_ajax_url, true)
```
### Send
Put a breakpoint `browser()` in R file
```R
session$registerDataObj(
    [..]
    filter = function(data, req) {
      shiny:::httpResponse(
        200, "application/json",
        {
          browser()
        `
```
and send the request in the internet browser
```javascript
req.send()
var jsonResponse = JSON.parse(req.responseText); 
```


## api_datasinus_ajax_url

### initialize
```javascript
var req = new XMLHttpRequest();
req.overrideMimeType("application/json");
```

### Post

####  without ProxyPass
`apps` is your PATH to Shiny Server Application
```javascript
req.open("POST", "http://192.168.1.XXX:3838/apps/RshinyBokehReticulatePOC/"+api_datasinus_ajax_url+'&operation=increment', true)
```
####  with ProxyPass
```javascript
req.open("POST", "http://192.168.1.XXX/shiny/apps/RshinyBokehReticulatePOC/"+api_datasinus_ajax_url+'&operation=increment', true)
```
####  within Rstudio Server
In   "open in internet browser" mode, where YYYY is the web service part of the rstudio given by Rstudio
```javascript
req.open("POST", "http://192.168.1.XXX:8787/p/YYYY/"+api_datasinus_ajax_url+'&operation=increment', true)
```
### Send
Put a breakpoint `browser()` in R file
```R
session$registerDataObj(
    [..]
    filter = function(data, req) {
      shiny:::httpResponse(
        200, "application/json",
        {
          browser()
```
and send the request in the internet browser
```javascript
req.send()
var jsonResponse = JSON.parse(req.responseText); 
```



