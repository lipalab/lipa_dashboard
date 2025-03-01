if (!require("lubridate")) install.packages("lubridate"); library("lubridate")



server <- function(input, output, session) {
  
  ### tab title text
  tab_title_text = reactive({
    
    x = c("<h1> <h1>")
    if(input$tabs == "home"){
      x = c("<h1>Welcome to the LIPA dashboard<h1>")
    }
    if(input$tabs == "phylogeny"){
      x = c("<h1>Phylogenetic relationships<h1>")
    }
    if(input$tabs == "trait"){
      x = c("<h1>Functional traits<h1>")
    }
    if(input$tabs == "geography"){
      x = c("<h1>Geographic distribution<h1>")
    }
    return(x)
    
  })
  ### tab title
  output$tab_title <-  renderUI({
    HTML(tab_title_text())
  })

  
  
}