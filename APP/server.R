if (!require("ape")) install.packages("ape"); library("ape")
if (!require("ggplot2")) install.packages("ggplot2"); library("ggplot2")
if (!require("ggtree")) install.packages("ggtree"); library("ggtree")
if (!require("plotly")) install.packages("plotly"); library("plotly")
if (!require("BiocManager")) install.packages("BiocManager")
if (!require("ggtree")) BiocManager::install("ggtree"); library("ggtree")

source("auxiliar.R")

############################### LOADING DATASETS ###############################

list_phylo_datasets = list.files(
  path = "datasets",
  pattern ="phylo"
)

list_trait_datasets =list.files(
  path = "datasets",
  pattern ="trait"
)


phylo_datasets = read.nexus(file = paste0("datasets/", list_phylo_datasets))

trait_datasets = read.csv(file = paste0("datasets/", list_trait_datasets))

#################################### SERVER ####################################

server <- function(input, output, session) {
  
  ### tab title - reactive
  observeEvent(input$tabs, {
    if(input$tabs == "home"){
      output$tab_title <-  renderUI({
        HTML("<h1>Welcome to the LIPA dashboard<h1>")
      })
    } 
    if(input$tabs == "phylogeny"){
      output$tab_title <-  renderUI({
        HTML("<h1>Phylogenetic relationships<h1>")
      })
    } 
    if(input$tabs == "trait"){
      output$tab_title <-  renderUI({
        HTML("<h1>Functional traits<h1>")
      })
    } 
    if(input$tabs == "geography"){
      output$tab_title <-  renderUI({
        HTML("<h1>Geographic distribution<h1>")
      })
    }
  })
  
  ### selection options for each tab
  observeEvent(input$tabs, {
    if(input$tabs == "phylogeny"){
      shinyjs::show("phylogeny_dataset")
      shinyjs::show("phylogeny_layout")
    } else {
      shinyjs::hide("phylogeny_dataset")
      shinyjs::hide("phylogeny_layout")
    }
  })

  ### plot 1 
  observe({
    
    if(input$tabs == "home"){
      output$plot_1 = plotly::renderPlotly({
        NULL
      })
    } 
    if(input$tabs == "phylogeny"){
      
      observe({
        output$plot_1 = plotly::renderPlotly({
          plot_phylo_tree(
            tr = phylo_datasets,
            layout = input$phylogeny_layout
          )
        })
      })
    } 
    if(input$tabs == "trait"){
      output$plot_1 = plotly::renderPlotly({
        NULL
      })
    } 
    if(input$tabs == "geography"){
      output$plot_1 = plotly::renderPlotly({
        NULL
      })
    }
  })
  
  ### plot 2
  observe({
    
    if(input$tabs == "home"){
      shinyjs::hide("plot_2")
    } 
    if(input$tabs == "phylogeny"){
      shinyjs::hide("plot_2")
    } 
    if(input$tabs == "trait"){
      output$plot_2 = plotly::renderPlotly({
        NULL
      })
    } 
    if(input$tabs == "geography"){
      shinyjs::hide("plot_2")
    }
  })
  
  
} # server closer