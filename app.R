#
# gNetwork_viz
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(igraph)
library(ggplot2)
library(ggraph)
library(shiny)
library(tidygraph)
library(tidyverse)
library(shinythemes)
# Define UI for application that draws a histogram
ui <- fluidPage(
    theme = shinytheme("sandstone"),
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
                        value = 120),
            textInput("from", "start path @ ", "A"),
            textInput("to", "end path @", "P"),
            checkboxInput("show_vertices","show vertices", value = TRUE ),
            checkboxInput("show_labels","show vertex labels", value = TRUE),
            checkboxInput("show_weight","show edge weight", value = TRUE),
            selectInput("edge_type","straight lines or arcs", c("straight lines", "arcs")),
            selectInput(inputId = "edge_colour", label = "edge colour", 
                        choices = colors(), selected = "darkgrey"),
            selectInput(inputId = "vertex_colour", label = "vertex colour",
                        choices = colors(), selected = "darkblue"),
            selectInput(inputId = "text_colour", label =  "text colour", 
                        choices = colors(), selected = "white"),
            submitButton("submit"),
            br(),
            a(href="https://github.com/arbkz/network_viz/blob/master/README.md", "click here for help")
            
        ),
        #  Main Panel 
        mainPanel(
           plotOutput("distPlot"),
           h4("shortest path:"),
           textOutput("gsp")
        )
    )
)
#### Server Logic
# worker function to return letter position 

letter_num<- function(letter) {
    LETINV <- data.frame(letter = LETTERS, pos = 1:26)
    LETINV[LETTERS == letter,][[2]]
}

# Define server logic (server.R)
server <- function(input, output) {
  
    output$distPlot <- renderPlot({
        # read inputs from ui.R
        vertex_count<- input$vertex
        edge_count <- input$edges
        edge_colour <- input$edge_colour
        vertex_colour <- input$vertex_colour
        text_colour <- input$text_colour
        
        set.seed(1234) # keep the graph consistent between 
        
        # generate a random graph
        edges <- data.frame(src = sample(x = LETTERS[1 : vertex_count], size = edge_count, replace = TRUE), 
                            dest = sample(x = LETTERS[1 : vertex_count], size = edge_count, replace = TRUE))
        edges <- group_by(edges, src,dest) %>% summarise(weight = n()) %>% ungroup
        nodes <- data.frame(num = 1 : vertex_count, label = LETTERS[1 : vertex_count])
        edges <- edges %>% left_join(nodes, by = c("src" = "label")) %>%  
            rename(src_id = num) %>% 
            left_join(nodes, by = c("dest" = "label")) %>% 
            rename(dest_id = num) %>% select(src_id, dest_id, weight)
        
        # create tidy graph object
        g_tidy <- tbl_graph(nodes = nodes, edges = edges, directed = TRUE)
        
        # calculate shortest path
        from <- input$from
        to <- input$to
        from_num <- letter_num(from)
        to_num <- letter_num(to)
        
        # input validation 
        active_letters <- LETTERS[seq(from = 1, to = vertex_count)]
        
        
        if (any(from == active_letters) && any(to == active_letters)) {
            p <- get.shortest.paths(graph = g_tidy, from = from_num, to = to_num)$vpath[[1]]
            
            if (length(p) != 1) output$gsp <- renderText(LETTERS[p])
            else output$gsp <- renderText("No path found")
        } 
        else { output$gsp <- renderText("start or end node does not exist")
          }
        #  plot with options based on  user input  
        g <-    if (input$edge_type != "arcs") {
                    ggraph(g_tidy, layout = "graphopt") + theme_graph()  + 
                        if (input$show_weight) geom_edge_link(aes(width = weight), alpha = 0.6, colour = edge_colour, arrow = arrow(angle = 30, type = "open")) 
                        else geom_edge_link(colour = edge_colour, arrow = arrow(angle = 30, type = "open"))
                }
                else {
                    ggraph(g_tidy, layout = "graphopt") + theme_graph()  + 
                        if (input$show_weight) geom_edge_arc(aes(width = weight), alpha = 0.6, colour = edge_colour, arrow = arrow(angle = 30, type = "open")) 
                        else geom_edge_arc(colour = edge_colour, arrow = arrow(angle = 30, type = "open"))
                        
                }
        g <- g + scale_edge_width(range = c(0.2, 2.5))      
        g <-    if (input$show_vertices) 
                    g + geom_node_point(colour = "black", cex = 8) + geom_node_point(colour = vertex_colour, cex = 7.5) 
                else 
                    g
        g <-   if (input$show_labels) 
            g + geom_node_text(aes(label = label), colour = text_colour, repel = FALSE, size = 4) 
        else 
            g
        
        g  
        
    })
    
}
    
# Run the application 
shinyApp(ui = ui, server = server)
