## https://rstudio.github.io/shinydashboard/structure.html
## https://github.com/tbradley1013/tree-subset-shiny build tree visualization

if (!require("plotly")) install.packages("plotly"); library("plotly")

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
    shinydashboard::menuItem(
      paste0("Last updated: ", "01/Mar/2025"),
      tabName = 'update', 
      icon = shiny::icon('calendar'),
      selected = FALSE
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
      ## plot phylogeny row
      fluidRow(
        column(
          width = 12,
          align = "center",
          plotOutput(
            "plot_phylogeny",  
            height= '600px',
            width = '900px'
          )
        )
      ),
      ## plot 1 row
      fluidRow(
        column(
          width = 12,
          align = "center",
          plotlyOutput(
            "plot_trait",  
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