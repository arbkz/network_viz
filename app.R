#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


library(ggplot2)
library(ggraph)
library(shiny)
library(tidygraph)
library(tidyverse)
# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("network graph visualiser"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("vertex",
                        "Number of vertices:",
                        min = 2,
                        max = 26,
                        value = 26),
            sliderInput("edges",
                        "Number of edges:",
                        min = 2,
                        max = 520,
                        value = 255),
            checkboxInput("show_vertices","show vertices", value = TRUE ),
            checkboxInput("show_labels","show vertex labels", value = TRUE),
            checkboxInput("show_weight","show edge weight", value = TRUE),
            selectInput("edge_type","straight lines or arcs", c("straight lines", "arcs")),
            textInput("edge_colour", "edge colour", "darkgrey"),
            textInput("vertex_colour", "vertex colour", "orange"),
            textInput("text_colour", "text colour", "blue"),
            submitButton("submit")
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        
        # generate inputs based on input$vertex from ui.R
        vertex_count<- input$vertex
        edge_count <- input$edges
        edge_colour <- input$edge_colour
        vertex_colour <- input$vertex_colour
        text_colour <- input$text_colour
        
        set.seed(1234)
        
        # generate some random data
        
        edges <- data.frame(src = sample(x = LETTERS[1 : vertex_count], size = edge_count, replace = TRUE), 
                            dest = sample(x = LETTERS[1 : vertex_count], size = edge_count, replace = TRUE))
        
        # generate nodes and edges 
        edges <- group_by(edges, src,dest) %>% summarise(weight = n()) %>% ungroup
        nodes <- data.frame(num = 1 : vertex_count, label = LETTERS[1 : vertex_count])
        edges <- edges %>% left_join(nodes, by = c("src" = "label")) %>%  
            rename(src_id = num) %>% 
            left_join(nodes, by = c("dest" = "label")) %>% 
            rename(dest_id = num) %>% select(src_id, dest_id, weight)
        
        # create tidy graph
        g_tidy <- tbl_graph(nodes = nodes, edges = edges, directed = TRUE)
        
        # plot graph
        # generate plot based on various user input options 
        g <-    if (input$edge_type != "arcs") {
                    ggraph(g_tidy, layout = "graphopt") + theme_graph()  + 
                        if (input$show_weight) geom_edge_link(aes(width = weight), alpha = 0.6, colour = edge_colour) 
                        else geom_edge_link(colour = edge_colour)
                }
                else {
                    ggraph(g_tidy, layout = "graphopt") + theme_graph()  + 
                        if (input$show_weight) geom_edge_arc(aes(width = weight), alpha = 0.6, colour = edge_colour) 
                        else geom_edge_arc(colour = edge_colour)
                        
                }
        g <- g + scale_edge_width(range = c(0.2, 2.5))       
         # act on input show labels
       
        
        
        g <-    if (input$show_vertices) 
                    g + geom_node_point(colour = "black", cex = 8) + geom_node_point(colour = vertex_colour, cex = 7.5) 
                else 
                    g
        
        g <-   if (input$show_labels) 
            g + geom_node_text(aes(label = label), colour = text_colour, repel = FALSE, size = 5) 
        else 
            g
        
        g  
        
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
