# network_viz
simple network visualisation shiny app for coursera's developing data products course

## Intro

This simple shiny app generates a network graph based on various input parameters.

The app:   

* Generates a random set of edges      
* Calculates the weight of each edge (based on the count of edges with the same source/destination)   
* Creates a tidy graph object from these edges    
* Plots the graph using ggplot with various graphical parameters based on user input   

## User Input Options

Check boxes, selectors and textbox inputs allow the user to:      

* Set the number of vertices (2-26)
* Set the number of edges (2-520)
* Show/hide vertices
* Show/hide vertex labels
* Scale edge width according to weight 
* Change the type of edge (arcs or straight lines)
* Change the colour of edges/vertices/labels

## Dependencies

The app uses: ggplot2, ggraph, shiny, tidygraph, tidyverse  

## Further Reading

For more information about network graph visualisations and tidygraph check out:

* [Intro to tidygraph](https://www.data-imaginist.com/2017/introducing-tidygraph/)   
* [Network analysis with R](https://www.jessesadler.com/post/network-analysis-with-r/)   
* [Static and dynamic network visualization with R](http://kateto.net/network-visualization)   



