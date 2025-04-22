### PARA FAZER:

if (!require("tidyverse")) install.packages("tidyverse"); require("tidyverse")
if (!require("data.table")) install.packages("data.table"); require("data.table")
if (!require("DT")) BiocManager::install("DT"); library("DT")
if (!require("ggplot2")) install.packages("ggplot2"); library("ggplot2")
if (!require("plotly")) install.packages("plotly"); library("plotly")
if (!require("leaflet")) install.packages("leaflet"); library("leaflet")
if (!require("leaflet.minicharts")) install.packages("leaflet.minicharts"); library("leaflet.minicharts")
if (!require("leaflegend")) install.packages("leaflegend"); library("leaflegend")
if (!require("ape")) install.packages("ape"); library("ape")
if (!require("BiocManager")) install.packages("BiocManager")
if (!require("ggtree")) BiocManager::install("ggtree"); library("ggtree")

source("auxiliar.R")

############################### LOADING DATASETS ###############################

### home data
ds_table = read.csv("datasets/0_dataset_table.csv")
metadata = read.csv("datasets/0_metadata.csv")
  
### phylogeny datasets
phylo_ds_files = list.files(
  path = "datasets",
  pattern ="phylo"
)
phylo_ds = lapply( paste0("datasets/", phylo_ds_files), read.nexus)

### trait datasets
trait_ds_files =list.files(
  path = "datasets",
  pattern ="trait"
)
trait_ds = lapply( paste0("datasets/", trait_ds_files), read.csv)

### geogrpahic datasets
geo_ds_files =list.files(
  path = "datasets",
  pattern ="geo"
)
geo_ds = lapply( paste0("datasets/", geo_ds_files), read.csv)

############################## PROCESSING DATASETS #############################

### naming datasets
phylo_ds_names = gsub(pattern = "phylo_|.tree", "", phylo_ds_files)
names(phylo_ds) = phylo_ds_names
trait_ds_names = gsub(pattern = "trait_|.csv", "", trait_ds_files)
names(trait_ds) = trait_ds_names 
geo_ds_names = gsub(pattern = "geo_|.csv", "", geo_ds_files)
names(geo_ds) = geo_ds_names 

### HTML for links
ds_table = ds_table %>% 
  mutate(DOI = case_when(
    !is.na(DOI) ~ paste0("<a href='",link,"'>",DOI,"</a>")
  )) %>% 
  select(!link)
    

#################################### SERVER ####################################

server <- function(input, output, session) {
  
  ### DATASET SELECTION
  observe({
    updateSelectInput(
      session, 
      inputId = "select_phylo_ds",
      choices = phylo_ds_names,
      selected = phylo_ds_names[1]
    )
    shinyWidgets::updatePickerInput(
      session,
      inputId = "select_trait_ds",
      choices = trait_ds_names,
      selected = trait_ds_names
    )
    shinyWidgets::updatePickerInput(
      session,
      inputId = "select_geo_ds",
      choices = geo_ds_names,
      selected = geo_ds_names
    )
  })
  ### REACTIVE DATASET
  ## phylogenetic tree
  phylo_tr = reactive({
    ## select phylogenetic tree
    tr = phylo_ds[[input$select_phylo_ds]]
    return(tr)
  })
  ## trait dataframe
  trait_df = reactive({
    ## select trait datasets
    tdl = trait_ds[input$select_trait_ds]
    ## bind to dataframe
    tdf = rbindlist(tdl, fill = T)
    ### return
    return(tdf)
  })
  ## geographic dataframe
  geo_df = reactive({
    ## select trait datasets
    gdl = geo_ds[input$select_geo_ds]
    ## bind to dataframe
    gdf = rbindlist(gdl, fill = T)
    ## filter geo by species
    # gdf = gdf %>% filter(species_reported %in% input$filter_geo_sp)
    return(gdf)
  })
  ### REACTIVE ELEMENTS
  ## trait filters
  observe({
    
    trait_source_vals = sort(unique(trait_df()$data_source))
    trait_sp_vals = sort(unique(trait_df()$species_reported))
    
    shinyWidgets::updatePickerInput(
      session,
      inputId = "filter_trait_source",
      choices = trait_source_vals,
      selected = trait_source_vals
    )
    shinyWidgets::updatePickerInput(
      session,
      inputId = "filter_trait_sp",
      choices = trait_sp_vals,
      selected = trait_sp_vals
    )
    
  })
  ## geographic filters
  observe({
    
    geo_source_vals = sort(unique(geo_df()$data_source))
    geo_country_vals = sort(unique(geo_df()$collection_country))
    geo_state_vals = sort(unique(geo_df()$collection_stateProvince))
    geo_sp_vals = sort(unique(geo_df()$species_reported))
    
    shinyWidgets::updatePickerInput(
      session,
      inputId = "filter_geo_source",
      choices = geo_source_vals,
      selected = geo_source_vals
    )
    shinyWidgets::updatePickerInput(
      session,
      inputId = "filter_geo_country",
      choices = geo_country_vals,
      selected = geo_country_vals
    )
    shinyWidgets::updatePickerInput(
      session,
      inputId = "filter_geo_state",
      choices = geo_state_vals,
      selected = geo_state_vals
    )
    shinyWidgets::updatePickerInput(
      session,
      inputId = "filter_geo_sp",
      choices = geo_sp_vals,
      selected = geo_sp_vals
    )
    
  })
  ## trait names
  trait_names = reactive({
    tn = colnames(trait_df()) 
    tn = tn[!grepl("key|data_source|species_reported|reference|notes", tn)]
    tn = sort(tn)
    return(tn)
  })
  ## categorical trait names
  cat_trait_names = reactive({
    tc = unlist(lapply(trait_df(), class))
    ctn = colnames(trait_df())[tc %in% c("character", "logical")]
    ctn = ctn[!grepl("key|data_source|species_reported|reference", ctn)]
    ctn = sort(ctn)
    return(ctn)
  })
  ## numerical trait names
  num_trait_names = reactive({
    tc = unlist(lapply(trait_df(), class))
    ntn = colnames(trait_df())[tc %in% c("integer", "numeric")]
    ntn = sort(ntn)
    return(ntn)
  })
  ## tab title
  observe({
    if(input$tabs == "home"){
      output$tab_title <-  renderUI({
        HTML("<h1>Welcome to the LIPA dashboard<h1>")
      })
    } 
    if(input$tabs == "metadata"){
      output$tab_title <-  renderUI({
        HTML("<h1>Metadata<h1>")
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
  ## selection box labels
  observe({
    if(input$tabs == "home"){
      shinyjs::hide("selection_1")
      shinyjs::hide("selection_2")
      shinyjs::hide("selection_3")
      shinyjs::hide("selection_4")
    }
    if(input$tabs == "metadata"){
      shinyjs::hide("selection_1")
      shinyjs::hide("selection_2")
      shinyjs::hide("selection_3")
      shinyjs::hide("selection_4")
    }
    if(input$tabs == "phylogeny"){
      output$selection_1_label = renderText({"Select a categorical trait"})
      output$selection_2_label = renderText({"Select a numerical trait"})
      output$selection_3_label = renderText({NULL})
      output$selection_4_label = renderText({NULL})
      shinyjs::show("selection_1")
      shinyjs::show("selection_2")
      shinyjs::hide("selection_3")
      shinyjs::hide("selection_4")
    }
    if(input$tabs == "trait"){
      output$selection_1_label = renderText({"X-axis trait"})
      output$selection_2_label = renderText({"Y-axis trait"})
      output$selection_3_label = renderText({NULL})
      output$selection_4_label = renderText({NULL})
      shinyjs::show("selection_1")
      shinyjs::show("selection_2")
      shinyjs::hide("selection_3")
      shinyjs::hide("selection_4")
      
    }
    if(input$tabs == "geography"){
      shinyjs::hide("selection_1")
      shinyjs::hide("selection_2")
      shinyjs::hide("selection_3")
      shinyjs::hide("selection_4")
    }
  })
  ## selection box choices
  observe({
    if(input$tabs == "phylogeny"){
      updateSelectInput(
        session, 
        "selection_1",
        choices = c("None", cat_trait_names())
      )
      updateSelectInput(
        session, 
        "selection_2",
        choices = c("None", num_trait_names())
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
  ## major display
  observe({
    if(input$tabs == "home"){
      shinyjs::show("table_ds")
      shinyjs::hide("table_metadata")
      shinyjs::hide("plot_phylogeny")
      shinyjs::hide("plot_trait")
      shinyjs::hide("plot_geography")
    }
    if(input$tabs == "metadata"){
      shinyjs::hide("table_ds")
      shinyjs::show("table_metadata")
      shinyjs::hide("plot_phylogeny")
      shinyjs::hide("plot_trait")
      shinyjs::hide("plot_geography")
    }
    if(input$tabs == "phylogeny"){
      shinyjs::hide("table_ds")
      shinyjs::hide("table_metadata")
      shinyjs::show("plot_phylogeny")
      shinyjs::hide("plot_trait")
      shinyjs::hide("plot_geography")
    }
    if(input$tabs == "trait"){
      shinyjs::hide("table_ds")
      shinyjs::hide("table_metadata")
      shinyjs::hide("plot_phylogeny")
      shinyjs::show("plot_trait")
      shinyjs::hide("plot_geography")
    }
    if(input$tabs == "geography"){
      shinyjs::hide("table_ds")
      shinyjs::hide("table_metadata")
      shinyjs::hide("plot_phylogeny")
      shinyjs::hide("plot_trait")
      shinyjs::show("plot_geography")
    }
    })
  ## home table of datasets
  observe({
    if(input$tabs == "home"){
      output$table_ds = DT::renderDT({
        datatable(ds_table, escape=FALSE)
      })
    } else {
      output$table_ds = DT::renderDT({NULL})
    }
  })
  ## metadata table
  observe({
    if(input$tabs == "metadata"){
      output$table_metadata = DT::renderDT({
        metadata
      })
    } else {
      output$table_metadata = DT::renderDT({NULL})
    }
  })
  ## plot phylogeny 
  observe({
    if(input$tabs == "phylogeny"){
        output$plot_phylogeny = plotly::renderPlotly({
          plot_phylo_fx(
            tr = phylo_tr(),
            df = trait_df(),
            trait1 = input$selection_1,
            trait2 = input$selection_2
          )
        })
    } else {
      output$plot_phylogeny = plotly::renderPlotly({NULL})
    }
  })
  ## plot trait
  observe({
    if(input$tabs == "trait"){
      output$plot_trait = plotly::renderPlotly({
        plot_trait_fx(
          df = trait_df(),
          x_axis = input$selection_1,
          y_axis = input$selection_2,
          dsource = input$filter_trait_source,
          species = input$filter_trait_sp
        )
      })
    } else {
      output$plot_trait = plotly::renderPlotly({NULL})
    }
  })
  ## plot geography
  observe({
    if(input$tabs == "geography"){
      output$plot_geography = leaflet::renderLeaflet({
        plot_geo_fx(
          df = geo_df(),
          dsource = input$filter_geo_source,
          country = input$filter_geo_country,
          state = input$filter_geo_state,
          species = input$filter_geo_sp
        )
      })
    } else {
      output$plot_geography = leaflet::renderLeaflet({NULL})
    }
    
  })
  
} # server closer