### LIBRARIES
if (!require("plotly")) install.packages("plotly"); library("plotly")
if (!require("leaflet")) install.packages("leaflet"); library("leaflet")

### phylogeny datasets names
phylo_ds_files = list.files(
  path = "datasets",
  pattern ="phylo"
)
phylo_ds_names = gsub(pattern = "phylo_|.tree", "", phylo_ds_files)

### trait datasets names
trait_ds_files =list.files(
  path = "datasets",
  pattern ="trait"
)
trait_ds_names = gsub(pattern = "trait_|.csv", "", trait_ds_files)

### geographic datasets names
geo_ds_files =list.files(
  path = "datasets",
  pattern ="geo"
)
geo_ds_names = gsub(pattern = "geo_|.csv", "", geo_ds_files)

### HEADER
header = shinydashboard::dashboardHeader(
  title = "LIPA dashboard",
  titleWidth  = 280
)

### SIDEBAR
sidebar = shinydashboard::dashboardSidebar(
  title = "",
  width = 280,
  collapsed = FALSE,
  
  shinydashboard::sidebarMenu( 
    id = "tabs",
    
    shinydashboard::menuItem(
      "Home", 
      tabName = 'home', 
      icon = shiny::icon('house'),
      selected = TRUE
    ),
    shinydashboard::menuItem(
      "Metadata", 
      tabName = 'metadata', 
      icon = shiny::icon('rectangle-list'),
      selected = FALSE
    ),
    shinydashboard::menuItem(
      "Phylogenetic relationships", 
      tabName = 'phylogeny', 
      icon = shiny::icon('diagram-project'),
      selected = FALSE
    ),
    shinydashboard::menuItem(
      "Functional traits", 
      tabName = 'trait', 
      icon = shiny::icon('leaf'),
      selected = FALSE
    ),
    shinydashboard::menuItem(
      "Geographic distribution", 
      tabName = 'geography', 
      icon = shiny::icon('globe'),
      selected = FALSE
    ),
    
    tags$hr(),
    
    shinydashboard::menuItem(
      "Select datasets",
      tabName = 'select_ds',
      icon = shiny::icon('database'),
      selected = FALSE,
      
      selectInput(
        inputId = "select_phylo_ds",
        label = "Phylogenetic tree",
        choices = c(),
        selected = c(),
        multiple = FALSE,
        width = "100%"
      ),
      shinyWidgets::pickerInput(
        inputId = "select_trait_ds",
        label = "Trait datasets",
        choices = c(),
        selected = c(),
        multiple = TRUE,
        options = shinyWidgets::pickerOptions(
          actionsBox = TRUE, 
          size = 10,
          selectedTextFormat = "count > 2"
        )
      ),
      shinyWidgets::pickerInput(
        inputId = "select_geo_ds",
        label = "Geographic datasets",
        choices = c(),
        selected = c(),
        multiple = TRUE,
        options = shinyWidgets::pickerOptions(
          actionsBox = TRUE, 
          size = 10,
          selectedTextFormat = "count > 2"
        )
      )
    ),
    shinydashboard::menuItem(
      "Filter traits",
      tabName = 'filter_trait',
      icon = shiny::icon('filter'),
      selected = FALSE,
      
      shinyWidgets::pickerInput(
        inputId = "filter_trait_source",
        label = "by source",
        choices = c(
          "experiment",
          "field",
          "herbarium",
          "literature"
        ),
        selected = c(
          "experiment",
          "field",
          "herbarium",
          "literature"
        ),
        multiple = TRUE,
        options = shinyWidgets::pickerOptions(
          actionsBox = TRUE, 
          size = 10,
          selectedTextFormat = "count > 1"
        )
      )
    )
    
  )
  
)
### BODY
body = shinydashboard::dashboardBody(
  
  shinydashboard::tabItem(
    tabName = '',
    shinydashboard::box( 
      title = "", 
      width = 12, 
      height = NULL,
      
      shinyjs::useShinyjs(), ## IMPORTANT: so shiny knows to use the shinyjs library
      
      ## title row
      fluidRow(
        column(
          width = 12, 
          align = "center",
          uiOutput("tab_title")
        )
      ),
      
      tags$hr(), tags$br(),
      
      fluidRow(
        column(width = 3,
               align = "left", 
               selectInput(
                 inputId = "selection_1",
                 label = textOutput("selection_1_label"), 
                 choices =  c(), 
                 width = "100%",
                 multiple = FALSE
                )
        ),
        column(width = 3,
               align = "left", 
               selectInput(
                 inputId = "selection_2",
                 label = textOutput("selection_2_label"), 
                 choices = c(), 
                 width = "100%",
                 multiple = FALSE
               )
        ),
        column(width = 3,
               align = "left", 
               selectInput(
                 inputId = "selection_3",
                 label = textOutput("selection_3_label"), 
                 choices = c(), 
                 width = "100%",
                 multiple = FALSE
               )
        ),
        column(width = 3,
               align = "left", 
               selectInput(
                 inputId = "selection_4",
                 label = textOutput("selection_4_label"), 
                 choices =  c(), 
                 width = "100%",
                 multiple = FALSE
               )
        )
      ),
      ## table of datasets 
      fluidRow(
        column(
          width = 12,
          align = "center",
          shiny::tableOutput(
            "table_ds"
          )
        )
      ),
      tags$br(),
      fluidRow(
        column(
          width = 12,
          align = "center",
          DT::DTOutput(
            "table_metadata"
          )
        )
      ),
      ## plot phylogeny 
      fluidRow(
        column(
          width = 12,
          align = "center",
          plotly::plotlyOutput(
            "plot_phylogeny",  
            height= '600px',
            width = '950px'
          )
        )
      ),
      ## plot trait
      fluidRow(
        column(
          width = 12,
          align = "center",
          plotly::plotlyOutput(
            "plot_trait",  
            height= '600px', 
            width = '900px'
          )
        )
      ),
      ## plot geogrpahy
      fluidRow(
        column(
          width = 12,
          align = "center",
          leaflet::leafletOutput(
            "plot_geography",  
            height= '600px', 
            width = '900px'
          )
        )
      )
    )
  ),


  ### customing 
  tags$head(tags$style(HTML('
                                /* logo */
                                .skin-blue .main-header .logo {
                                background-color: #CDAD00;
                                color: black;
                                }
                                
                                /* logo when hovered */
                                .skin-blue .main-header .logo:hover {
                                background-color: #CDAD00;
                                }
                            
                                 /* sidebar toggle */
                                .skin-blue .main-header .navbar .sidebar-toggle {
                                background-color: #CDAD00;
                                color: black;
                                }
                                
                                /* sidebar toggle when hovered */
                                .skin-blue .main-header .navbar .sidebar-toggle:hover {
                                background-color: #CDAD00;
                                color: darkred;
                                }
                            
                                /* navbar (rest of the header) */
                                .skin-blue .main-header .navbar {
                                background-color: #CDAD00;
                                }
                                
                                /* main sidebar */
                                .skin-blue .main-sidebar {
                                background-color: #222d32;
                                }
                                
                                /* main background colour*/
                                .content-wrapper{
                                background-color: #222d32;
                                }
                               
                                /* navigation tabs */
                                .nav-tabs-custom>.tab-content {
                                background: #F3F9FD;
                                }
                            
                                .main-header {min-height: 75px}
                            
                                /* header 1 */
                                .h1, h1 { 
                                font-size: 4em;
                                font-weight: bold;
                                color: black;
                                background-color: white;
                                }
                            
                                /* header 2 */
                                .h2, h2 { 
                                font-size: 1em;
                                font-weight: bold;
                                color: black;
                                background-color: transparent;
                                }
                            
                            ')
  ))

)

### UI
ui = shinydashboard::dashboardPage(header, sidebar, body)