## https://rstudio.github.io/shinydashboard/structure.html

header = shinydashboard::dashboardHeader(
  title = "LIPA dashboard",
  disable = FALSE, 
  titleWidth  = 280
)

sidebar = shinydashboard::dashboardSidebar(
  title = "",
  width = 280,
  collapsed = FALSE,
 
  shinydashboard::menuItem( 
    "tab 1", 
    tabName = 'tab1',
    icon =  shiny::icon('globe'), 
    selected = FALSE
  )
  
)

body = shinydashboard::dashboardBody(
 
  ## customizar a barra superior e lateral 
  tags$head(tags$style(HTML('
                                /* logo */
                                .skin-blue .main-header .logo {
                                background-color: #CDAD00;
                                }
                                
                                /* logo when hovered */
                                .skin-blue .main-header .logo:hover {
                                background-color: #CDAD00;
                                }
                            
                                 /* sidebar toggle */
                                .skin-blue .main-header .navbar .sidebar-toggle {
                                background-color: #CDAD00;
                                color: #ffff;
                                }
                                
                                /* sidebar toggle */
                                .skin-blue .main-header .navbar .sidebar-toggle:hover {
                                background-color: #CDAD00;
                                color: #ffff;
                                }
                            
                                /* navbar (rest of the header) */
                                .skin-blue .main-header .navbar {
                                background-color: #CDAD00;
                                }
                                
                                /* main sidebar */
                                .skin-blue .main-sidebar {
                                background-color: black;
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
                                '
                            )
  ))

)

### UI
ui = shinydashboard::dashboardPage(header, sidebar, body)