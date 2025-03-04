if (!require("tidyverse")) install.packages("tidyverse"); require("tidyverse")
if (!require("data.table")) install.packages("data.table"); require("data.table")
if (!require("ggplot2")) install.packages("ggplot2"); library("ggplot2")
if (!require("plotly")) install.packages("plotly"); library("plotly")
if (!require("ape")) install.packages("ape"); library("ape")
if (!require("BiocManager")) install.packages("BiocManager")
if (!require("ggtree")) BiocManager::install("ggtree"); library("ggtree")

source("auxiliar.R")

############################### LOADING DATASETS ###############################

### phylogeny datasets names
phylo_ds_files = list.files(
  path = "datasets",
  pattern ="phylo"
)

### trait datasets names
trait_ds_files =list.files(
  path = "datasets",
  pattern ="trait"
)

### read datasets into lists
phylo_ds = lapply( paste0("datasets/", phylo_ds_files), read.nexus)
trait_ds = lapply( paste0("datasets/", trait_ds_files), read.csv)

### naming datasets
phylo_ds_names = gsub(pattern = "phylo_|.tree", "", phylo_ds_files)
names(phylo_ds) = phylo_ds_names
trait_ds_names = gsub(pattern = "trait_|.csv", "", trait_ds_files)
names(trait_ds) = trait_ds_names 

#################################### SERVER ####################################

server <- function(input, output, session) {
  
  ### rective datasets
  ## phylogenetic tree
  phylo_tr = reactive({
    
    tr = phylo_ds[["JR2025"]]
    
    return(tr)
    
  })
  ## trait dataframe
  trait_df = reactive({
    
    trait_filt = trait_ds
    ### filtering functions
    df = rbindlist(trait_filt, fill = T)
    return(df)
    
  })
  ## trait names
  trait_names = reactive({
    tn = colnames(trait_df()) 
    tn = tn[!grepl("key|data_source|species_reported|experiment_", tn)]
    tn = sort(tn)
    return(tn)
  })
  
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
  ### selection titles 
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
  ### selection choices
  observe({
    if(input$tabs == "phylogeny"){
      updateSelectInput(
        session, 
        "selection_1",
        choices = phylo_ds_names
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
        choices = trait_names()
      )
      updateSelectInput(
        session, 
        "selection_2",
        choices = c("None", trait_names())
      )
    }
  })
  ### plot to display
  observe({
    if(input$tabs == "phylogeny"){
      shinyjs::show("plot_phylogeny")
      shinyjs::hide("plot_trait")
    }
    if(input$tabs == "trait"){
      shinyjs::hide("plot_phylogeny")
      shinyjs::show("plot_trait")
    }
    })
    
  ### plot phylogeny 
  observe({
    if(input$tabs == "phylogeny"){
        output$plot_phylogeny = shiny::renderPlot({
          plot_phylo_fx(
            tr = phylo_tr(),
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
        plot_trait_fx(
          df = trait_df(),
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