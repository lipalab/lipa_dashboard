
### plot phylogenetic tree
plot_phylo = function(tr, layout){
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

plot_trait = function(df, x_axis, y_axis, group){
  
  ### titles
  ## x axis
  x_axis_title = gsub(pattern ="_",
                      replacement = " ",
                      x_axis
                      )
  ## y axis
  y_axis_title = gsub(pattern ="_",
                      replacement = " ",
                      y_axis
                      )

  ### BAR
  if(type == "bar"){
    ## processing df
    df = df %>% 
      group_by(bacteroid_type) %>% 
      reframe(n = n())
    
    ## plotting
    plot_trait = plot_ly() %>% 
      add_trace(x = df[[x_axis]], 
                y = df[["n"]],
                type = type,  
                orientation = 'v',
                # color = factor(virus_se[["virus"]], levels=rev(todos_virus) ),
                # colors =  cores_virus,
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
  
  ### return
  return(plot_trait)
  
}
