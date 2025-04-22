
### plot phylogenetic tree
plot_phylo_fx = function(tr, 
                         df, 
                         trait1, 
                         trait2){
  
  ## plot base phylogeny
  phy1 = ggtree::ggtree(
      tr = tr,
      ladderize = TRUE
  ) 
  ## tip data
  phy_data = phy1$data %>% 
    rename(species = label,
           time = x,
           order = y)
  ## taxonomy
  split_names = strsplit(split = "_", phy_data$species)
  taxon = sapply(split_names,"[[",1)
  phy_data$taxon = taxon
  ## min value for X axis
  xmin = max(phy_data$time) + 0.8
  ## point size based on number of tips
  point_size = (0.5 * 300)/Ntip(tr)
  ## parameters to display
  tooltip = c("time","species")
  ## taxon colors
  taxon_colors = c(
    "Batesia" = "darkgreen",
    "Cassia" = "darkred",
    "Chamaecrista" = "gold",
    "Melanoxylon" = "darkgoldenrod",
    "Recordoxylon" = "darkblue",
    "Senna" = "lightpink",
    "Vouacapoua" = "lightgreen"
  )
  ## defatul phylo plot
  phy2 = phy1 +
    geom_point(data = phy_data,
               aes(
                 label = species,
                 x = time,
                 y = order,
                 colour = taxon
               ),
               shape = 21,
               size = point_size
    )+ scale_color_manual(values = taxon_colors)
  
  if(trait1 != "None") {
    ## processing df 
    df1 = df %>% 
      rename(species = species_reported) %>% 
      select_at(c("species",trait1) )
    ### trait data
    data1 = phy_data[1:Ntip(tr),]
    data1 = data1 %>% 
      left_join(df1, by = "species")
    ## add first trait
    phy2 = phy1 +
      geom_point(data = data1,
                 aes(
                   label = species,
                   x = xmin+0.1,
                   y = order,
                   colour = get(trait1)
                 ),
                 shape = 22,
                 size = point_size*1.1
                 )
    ## update tooltip
    tooltip = c("species", "get(trait1)")
  }
  ## check second trait
  if(trait2 != "None"){
    ## make symbolic
    trait2 = sym(trait2)
    ## mean trait value per species 
    df1 = df %>% 
      rename(species = species_reported) %>% 
      group_by(species) %>% 
      reframe(trait2 = mean(!!trait2, na.rm = T)) 
    ## join species with trait values
    data2 = phy_data[1:Ntip(tr),]
    data2 = data2 %>% 
      select("species", "order") %>% 
      left_join(df1, by ="species") %>% 
      mutate(X = xmin + 0.8) %>% 
      rename(Y = order)
    
    ## add to previous tree 
    if(trait1 != "None"){
      phy2 = phy2 +
        geom_tile(data = data2,
                  aes(
                    label = species,
                    x = X,
                    y = Y,
                    fill = trait2
                  )
        ) 
    } else {
      phy2 = phy1 +
        geom_tile(data = data2,
                  aes(
                    label = species,
                    x = X,
                    y = Y,
                    fill = trait2
                  )
        ) 
    }
    
    ## update tooltip
    tooltip = c("species","get(trait1)", "trait2")
  }
  
  ### convert to plotly
  plot_phylo = plotly::ggplotly(phy2, tooltip = tooltip)
  ### return
  return(plot_phylo)
}

### plot trait data
plot_trait_fx = function(df, 
                         x_axis, 
                         y_axis, 
                         dsource,
                         species){
  
  ## filter traits
  df = df %>% filter(data_source %in% dsource)
  df = df %>% filter(species_reported %in% species)
  
  if(nrow(df) == 0){
    
    plot_trait = plotly_empty(
      type = "scatter", 
      mode = "markers") %>%
      
      config(
        displayModeBar = FALSE
      ) %>%
      
      layout(
        title = list(
          text = "There is no data for your selection",
          yref = "paper",
          y = 0.5
        )
      )
    
  } else {
    ### x axis
    x_axis_class = class(df[[x_axis]])
    x_axis_title = gsub(pattern ="_",
                        replacement = " ",
                        x_axis
    )
    ### y axis
    y_axis_class = "no class"
    if(y_axis != "None"){
      y_axis_class = class(df[[y_axis]])
      y_axis_title = gsub(pattern ="_",
                          replacement = " ",
                          y_axis
      )
    }
    ### BAR PLOT FOR CATEGORICAL X AXIS
    if(x_axis_class %in% c("character","logical") &
       y_axis == "None"){
      
      ## processing df
      df = df %>% 
        group_by_at(x_axis) %>% 
        reframe(n = n())
      
      ## plotting
      plot_trait = plot_ly() %>% 
        add_trace(x = df[[x_axis]], 
                  y = df[["n"]],
                  type = "bar",  
                  orientation = 'v',
                  opacity = 0.75,
                  hoverinfo = 'text',
                  textposition = 'none',
                  text = paste('</br>',df[[x_axis]],
                               '</br> n: ',df[["n"]]
                  ) 
        ) %>%
        layout(bargap = 0.1, 
               barmode = 'stack',
               xaxis = list(title = list(text = x_axis_title,
                                         font = list(size = 14)),
                            tickvals = df[[x_axis]],
                            ticktext = df[[x_axis]],
                            zeroline = FALSE, 
                            mirror = FALSE,
                            showline = FALSE, 
                            linewidth = 1, 
                            linecolor = 'black',
                            showgrid = FALSE
               ),
               yaxis = list(title = list(text = "Number of entries", 
                                         font = list(size = 14)),
                            zeroline = FALSE, 
                            mirror = FALSE,
                            showline = FALSE, 
                            linewidth = 1, 
                            linecolor = 'black',
                            showgrid = FALSE
               ), 
               
               legend = list(orientation = 'h', 
                             xanchor = "center",
                             x = 0.5,
                             y = -0.15,
                             font = list(size = 12)
                             
               )
               
        )
      
    }
    ### HISTOGRAM FOR NUMERICAL X AXIS
    if(x_axis_class %in% c("integer","numeric") & 
       y_axis == "None"){
      
      ## plotting
      plot_trait = plot_ly() %>% 
        add_trace(x = df[[x_axis]], 
                  type = "histogram", 
                  opacity = 0.75
                  
        ) %>%
        layout(bargap = 0.1, 
               barmode = 'stack',
               xaxis = list(title = list(text = x_axis_title,
                                         font = list(size = 14)),
                            zeroline = FALSE, 
                            mirror = FALSE,
                            showline = FALSE, 
                            linewidth = 1, 
                            linecolor = 'black',
                            showgrid = FALSE
               ),
               yaxis = list(title = list(text = "Number of entries", 
                                         font = list(size = 14)),
                            zeroline = FALSE, 
                            mirror = FALSE,
                            showline = FALSE, 
                            linewidth = 1, 
                            linecolor = 'black',
                            showgrid = FALSE
               ), 
               
               legend = list(orientation = 'h', 
                             xanchor = "center",
                             x = 0.5,
                             y = -0.15,
                             font = list(size = 12)
                             
               )
               
        )
      
    }
    ### BOX PLOT VERTICAL
    if(x_axis_class %in% c("character","logical") & 
       y_axis_class %in% c("integer","numeric")){
      
      ## plotting
      plot_trait = plot_ly() %>% 
        
        add_trace(
          x = df[[x_axis]], 
          y = df[[y_axis]], 
          type = "box", 
          opacity = 0.75
        ) %>%
        layout(
          xaxis = list(title = list(text = x_axis_title,
                                    font = list(size = 14)),
                       zeroline = FALSE, 
                       mirror = FALSE,
                       showline = FALSE, 
                       linewidth = 1, 
                       linecolor = 'black',
                       showgrid = FALSE
          ),
          yaxis = list(title = list(text = y_axis_title, 
                                    font = list(size = 14)),
                       zeroline = FALSE, 
                       mirror = FALSE,
                       showline = FALSE, 
                       linewidth = 1, 
                       linecolor = 'black',
                       showgrid = FALSE
          ), 
          
          legend = list(orientation = 'h', 
                        xanchor = "center",
                        x = 0.5,
                        y = -0.15,
                        font = list(size = 12)
                        
          )
          
        )
      
    }
    ### BOX PLOT HORIZONTAL
    if(x_axis_class %in% c("integer","numeric") & 
       y_axis_class %in% c("character","logical")){
      
      ## plotting
      plot_trait = plot_ly() %>% 
        
        add_trace(
          x = df[[x_axis]], 
          y = df[[y_axis]], 
          type = "box", 
          opacity = 0.75
        ) %>%
        layout(
          xaxis = list(title = list(text = x_axis_title,
                                    font = list(size = 14)),
                       zeroline = FALSE, 
                       mirror = FALSE,
                       showline = FALSE, 
                       linewidth = 1, 
                       linecolor = 'black',
                       showgrid = FALSE
          ),
          yaxis = list(title = list(text = y_axis_title, 
                                    font = list(size = 14)),
                       zeroline = FALSE, 
                       mirror = FALSE,
                       showline = FALSE, 
                       linewidth = 1, 
                       linecolor = 'black',
                       showgrid = FALSE
          ), 
          
          legend = list(orientation = 'h', 
                        xanchor = "center",
                        x = 0.5,
                        y = -0.15,
                        font = list(size = 12)
                        
          )
          
        )
    }
    ### SCATTER PLOT 
    if(x_axis_class %in% c("integer","numeric") & 
       y_axis_class %in% c("integer","numeric")){
      
      ## plotting
      plot_trait = plot_ly() %>% 
        add_trace(x = df[[x_axis]], 
                  y = df[[y_axis]], 
                  type = "scatter", 
                  opacity = 0.75,
                  hoverinfo = 'text',
                  textposition = 'none',
                  text = paste('</br> x: ',df[[x_axis]],
                               '</br> y: ',df[[y_axis]]
                  ) 
                  
        ) %>%
        layout(bargap = 0.1, 
               barmode = 'stack',
               xaxis = list(title = list(text = x_axis_title,
                                         font = list(size = 14)),
                            zeroline = FALSE, 
                            mirror = FALSE,
                            showline = FALSE, 
                            linewidth = 1, 
                            linecolor = 'black',
                            showgrid = FALSE
               ),
               yaxis = list(title = list(text = y_axis_title, 
                                         font = list(size = 14)),
                            zeroline = FALSE, 
                            mirror = FALSE,
                            showline = FALSE, 
                            linewidth = 1, 
                            linecolor = 'black',
                            showgrid = FALSE
               ), 
               
               legend = list(orientation = 'h', 
                             xanchor = "center",
                             x = 0.5,
                             y = -0.15,
                             font = list(size = 12)
                             
               )
               
        )
      
    }
    ### HEATMAP
    if(x_axis_class %in% c("character","logical") & 
       y_axis_class %in% c("character","logical")){
      
      ## processing data
      df = df %>% 
        group_by_at(c(x_axis, y_axis)) %>% 
        reframe(n = n())
      
      ## plotting
      plot_trait = plot_ly() %>% 
        add_trace(x = df[[x_axis]], 
                  y = df[[y_axis]],
                  z = df[["n"]],
                  type = "heatmap", 
                  opacity = 0.75,
                  hoverinfo = 'text',
                  text = paste('</br>',df[[x_axis]],
                               '</br>',df[[y_axis]],
                               '</br> n: ',df[["n"]]
                  ) 
                  
        ) %>%
        layout(bargap = 0.1, 
               barmode = 'stack',
               xaxis = list(title = list(text = x_axis_title,
                                         font = list(size = 14)),
                            zeroline = FALSE, 
                            mirror = FALSE,
                            showline = FALSE, 
                            linewidth = 1, 
                            linecolor = 'black',
                            showgrid = FALSE
               ),
               yaxis = list(title = list(text = y_axis_title, 
                                         font = list(size = 14)),
                            zeroline = FALSE, 
                            mirror = FALSE,
                            showline = FALSE, 
                            linewidth = 1, 
                            linecolor = 'black',
                            showgrid = FALSE
               ), 
               
               legend = list(orientation = 'h', 
                             xanchor = "center",
                             x = 0.5,
                             y = -0.15,
                             font = list(size = 12)
                             
               )
               
        )
      
    }
    
  }
  
  ### return
  return(plot_trait)
  
}

### plot geographic data
plot_geo_fx = function(df,
                       dsource,
                       country,
                       state,
                       species){
  
  ### filter coordinates
  df = df %>% filter(data_source %in% dsource)
  df = df %>% filter(collection_country %in% country)
  df = df %>% filter(collection_stateProvince %in% state)
  df = df %>% filter(species_reported %in% species)
  
  ### plot map
  if(nrow(df) == 0){ ## if dataset empty
    plot_map = leaflet() %>%
      addProviderTiles(providers$OpenTopoMap) %>% 
      setView(lng = -46.565744, lat =-23.677659, zoom= 2) 
  } else { ## if not
    plot_map = leaflet(data = df) %>%
      addProviderTiles(providers$OpenTopoMap) %>% 
      addCircleMarkers(
        lng = ~coord_longitude, 
        lat = ~coord_latitude, 
        radius = 2.5,
        color = "black",
        weight = 2,
        fillColor = "gold",
        fillOpacity = 0.4,
        popup = ~as.character(species_reported), 
        label = ~as.character(species_reported)
      ) %>% 
      setView(lng = -46.565744, lat =-23.677659, zoom= 2) 
  }
  
  ### return
  return(plot_map)
    
}
