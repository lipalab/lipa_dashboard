## https://rstudio.github.io/shinydashboard/structure.html
## https://github.com/tbradley1013/tree-subset-shiny build tree visualization

last_updated = "26/Feb/2024"

### HEADER
header = shinydashboard::dashboardHeader(
  title = HTML("<b>LIPA dashboard<b>"),
  disable = FALSE, 
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
  
  shinydashboard::box( 
      title = uiOutput("tab_title"), 
      footer = NULL, 
      status = NULL,
      solidHeader = FALSE, 
      background = NULL, 
      width = 12, 
      height = NULL,
      collapsible = FALSE, 
      collapsed = FALSE
      ),
  
  # shinydashboard::tabItems(
  #   shinydashboard::tabItem(
  #     fluidRow(
  #       column(width = 12,
  #              align = "center"
  #       )
  #     )
  #   )
  # ),
  
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
                                
                                /* header 1 */
                                .h1, h1 { 
                                font-size: 4em;
                                font-weight: bold;
                                color: black;
                                background-color: white;
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
                            
                            ')
  ))

)

### UI
ui = shinydashboard::dashboardPage(header, sidebar, body)