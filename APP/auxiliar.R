
### plot phylogenetic tree
plot_phylo_fx = function(tr, layout){
  ## number of tips
  ntip= Ntip(tr)
  ## font size based on number of tips
  font_size = (1.5 * 300)/ntip
  ## plot phylogeny
  plot_phylo = ggtree::ggtree(
    tr = tr,
    ladderize = TRUE,
    layout = layout
  ) +
  ggtree::geom_tiplab(
    size = font_size
  )
  ## return
  return(plot_phylo)
}

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
