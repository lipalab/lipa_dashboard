if (!require("tidyverse")) install.packages("tidyverse"); require("tidyverse")
if (!require("ggplot2")) install.packages("ggplot2"); library("ggplot2")
if (!require("plotly")) install.packages("plotly"); library("plotly")
if (!require("ape")) install.packages("ape"); library("ape")
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

trait_datasets = read.csv(file = paste0("datasets/", list_trait_datasets),
                          na.strings = "na")



#################################### SERVER ####################################

server <- function(input, output, session) {
  
  ### tab title
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
  ### selection boxes 
  observe({
    if(input$tabs == "home"){
      shinyjs::hide("selection_1")
      shinyjs::hide("selection_2")
      shinyjs::hide("selection_3")
      shinyjs::hide("selection_4")
    }
    if(input$tabs == "phylogeny"){
      output$selection_1_label = renderText({"Select a phylogeny"})
      output$selection_2_label = renderText({"Select a layout"})
      output$selection_3_label = renderText({"Select a continous trait"})
      output$selection_4_label = renderText({"Select a discrete trait"})
      shinyjs::show("selection_1")
      shinyjs::show("selection_2")
      shinyjs::show("selection_3")
      shinyjs::show("selection_4")
    }
    if(input$tabs == "trait"){
      output$selection_1_label = renderText({"X axis trait"})
      output$selection_2_label = renderText({"Y axis trait"})
      output$selection_3_label = renderText({"Grouping variable"})
      output$selection_4_label = renderText({"Apply a filter"})
      shinyjs::show("selection_1")
      shinyjs::show("selection_2")
      shinyjs::hide("selection_3")
      shinyjs::hide("selection_4")
      
    }
  })
  ### choices
  observe({
    if(input$tabs == "phylogeny"){
      updateSelectInput(
        session, 
        "selection_1",
        choices = c("Rando 2025")
      )
      updateSelectInput(
        session, 
        "selection_2",
        choices = c(
          'rectangular',
          'slanted',
          'fan',
          'circular',
          'radial'
        )
      )
    }
    if(input$tabs == "trait"){
      updateSelectInput(
        session, 
        "selection_1",
        choices = c("bacteriod_type")
      )
      updateSelectInput(
        session, 
        "selection_2",
        choices = c("bacteriod_type")
      )
    }
  })
  
  ### plot phylogeny 
  observe({
    if(input$tabs == "phylogeny"){
        output$plot_phylogeny = shiny::renderPlot({
          plot_phylo(
            tr = phylo_datasets,
            layout = input$selection_2
          )
        })
    } else {
      output$plot_phylogeny = shiny::renderPlot({NULL})
    }
  })
  ### plot trait
  observe({
    if(input$tabs == "trait"){
      output$plot_trait = plotly::renderPlotly({
        plot_trait(
          df = trait_datasets,
          x_axis = input$selection_1,
          y_axis = input$selection_2,
          group = input$selection_3
        )
      })
    } else {
      output$plot_trait = plotly::renderPlotly({NULL})
    }
  })
  
  
} # server closer