
### plot phylogenetic tree
plot_phylo_fx = function(tr, df, trait1, trait2){
  
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
  
    ## add taxonomy
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
  
  if(trait1 != "None" & trait2 == "None") {
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
                   x = max(time)+0.2,
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
  if(trait1 != "None" & trait2 != "None"){
    ## rename species column 
    df1 = df %>% 
      rename(species = species_reported) %>% 
      select_at(c("species",trait1, trait2) )
    ### join
    data2 = phy_data[1:Ntip(tr),]
    data2 = data2 %>% 
      left_join(df1, by = "species")
    ## add second trait  
    phy2 = phy1 +
      
      geom_point(data = data2,
                 aes(
                   label = species,
                   x = max(time)+0.2,
                   y = order,
                   colour = get(trait1)
                 ),
                 shape = 22,
                 size = point_size*1.1
      ) +
      geom_point(data = data2,
                 aes(
                   label = species,
                   x = max(time)+0.4,
                   y = order,
                   colour = get(trait2)
                 ),
                 shape = 22,
                 size = point_size*1.1
      ) 
    ## update tooltip
    tooltip = c("species", "get(trait1)","get(trait2)")
  }
  
  ### convert to plotly
  plot_phylo = plotly::ggplotly(phy2, tooltip = tooltip)
  ### return
  return(plot_phylo)
}

### plot traits
plot_trait_fx = function(df, x_axis, y_axis, group){
  ## x axis
  x_axis_class = class(df[[x_axis]])
  x_axis_title = gsub(pattern ="_",
                      replacement = " ",
                      x_axis
                      )
  ## y axis
  if(y_axis != "None"){
      y_axis_class = class(df[[y_axis]])
      y_axis_title = gsub(pattern ="_",
                          replacement = " ",
                          y_axis
    )
  }

  ### SINGLE BAR PLOT FOR CATEGORICAL X AXIS
  if(x_axis_class %in% c("character","factor") & y_axis == "None"){
    ## processing df
    df_proc = df %>% 
      group_by_at(x_axis) %>% 
      reframe(n = n())
    
    ## plotting
    plot_trait = plot_ly() %>% 
      add_trace(x = df_proc[[x_axis]], 
                y = df_proc[["n"]],
                type = "bar",  
                orientation = 'v',
                # color = factor(virus_se[["virus"]], levels=rev(todos_virus) ),
                # colors =  cores_virus,
                opacity = 0.75,
                hoverinfo = 'text',
                textposition = 'none',
                text = paste('</br>',df_proc[[x_axis]],
                             '</br> n: ',df_proc[["n"]]
                ) 
      ) %>%
      layout(bargap = 0.1, 
             barmode = 'stack',
             xaxis = list(title = list(text = x_axis_title,
                                       font = list(size = 14)),
                          tickvals = df_proc[[x_axis]],
                          ticktext = df_proc[[x_axis]],
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
  
  ### return
  return(plot_trait)
  
}
