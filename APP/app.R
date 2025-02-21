################################### LIBRARIES ##################################

if (!require("shiny")) install.packages("shiny"); require("shiny")
if (!require("shinydashboard")) install.packages("shinydashboard"); require("shinydashboard")
if (!require("shinyWidgets")) install.packages("shinyWidgets"); require("shinyWidgets")
if (!require("shinyjs")) install.packages("shinyjs"); require("shinyjs")
if (!require("shinyauthr")) install.packages("shinyauthr"); require("shinyauthr")
if (!require("bs4Dash")) install.packages("bs4Dash"); require("bs4Dash")

################################ RUNNING APP ###################################

### user interface
source("ui.R", encoding = "UTF-8")

### server
source("server.R", encoding = "UTF-8")

### running
shiny::shinyApp(
  ui = ui, 
  server = server
)