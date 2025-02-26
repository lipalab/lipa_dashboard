## https://rstudio.github.io/shinydashboard/structure.html


date_update = "26/Feb/2024"

### HEADER
header = shinydashboard::dashboardHeader(
  title = "LIPA dashboard",
  disable = FALSE, 
  titleWidth  = 280
)

### SIDEBAR
sidebar = shinydashboard::dashboardSidebar(
  title = "",
  width = 280,
  collapsed = FALSE,
  
  shinydashboard::sidebarMenu( 
    
    shinydashboard::menuItem(
      "Plant traits", 
      tabName = 'traits', 
      icon = shiny::icon('leaf'),
      selected = TRUE
    ),
    shinydashboard::menuItem(
      "Geographic distribution", 
      tabName = 'geodis', 
      icon = shiny::icon('globe'),
      selected = FALSE
    )
  )
)
### BODY
body = shinydashboard::dashboardBody(
 
  shinydashboard::tabItems(
    shinydashboard::tabItem(
      tabName = "geodis",
      fluidRow(
        column(width = 12,
               align = "center",
               tags$h1("Title")
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