
### plot phylogenetic tree
plot_phylo_tree = function(tr, layout){
  
  plot_phylo = ggtree::ggtree(
    tr = tr,
    ladderize = TRUE,
    layout = layout
  ) +
  ggtree::geom_tiplab()
  
  plotly::ggplotly(plot_phylo)
  
}
