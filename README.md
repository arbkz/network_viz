# network_viz

Network graph visualisation shiny app 

## Intro

This  simple shiny app plots a random network graph and prints the shortest path between any 2 points

The app:   

* Generates a random directed weighted graph    
* Creates a tidy graph object from these edges    
* Finds the shortest path between 2 vertices
* Plots the graph using ggplot with various graphical parameters determined by the user input

## User Input Options

**The Graph** .  
* Set the number of vertices (2-26)
* Set the number of edges (2-520)

**Shortest Path**

The user can choose any start and end node name from A-Z and These will be the start and end node for the shortest path calculation.

**Graphical Parameters**

* Show/hide vertices
* Show/hide vertex labels

* Change edge width according to edge weight 
* Change the type of edge (arcs or straight lines)
* Change the colour of edges/vertices/labels

## Dependencies

The app uses: ggplot2, ggraph, shiny, tidygraph, tidyverse  

## Further Reading

For more information about network graph visualisations and tidygraph check out:

* [Intro to tidygraph](https://www.data-imaginist.com/2017/introducing-tidygraph/)   
* [Network analysis with R](https://www.jessesadler.com/post/network-analysis-with-r/)   
* [Static and dynamic network visualization with R](http://kateto.net/network-visualization)   



