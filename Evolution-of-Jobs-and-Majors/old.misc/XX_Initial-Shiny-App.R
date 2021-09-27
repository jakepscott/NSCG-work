library(shiny)
library(here)
library(tidyverse)
library(ggiraph)

data <- read_csv(here("Data/Jobs-by-Major-and-Year.csv"))

ui <- fluidPage({
  sidebarLayout(
    sidebarPanel(
      selectizeInput("major", 
                     "Which major to analyze:", 
                     options = sort(unique(data$Major_Label))),
      sliderInput("minpercent", "Minimum percent of people with job", 
                  min = 0, max = 100,
                  value = c(5), step = 1)
    ),
    mainPanel(ggiraphOutput("plot"))
    )
  })

server <- function(input, output, session) {
  output$plot <- renderggiraph({
    (plot <- data %>% 
       filter(!!as.symbol(input$major))  %>% 
       filter(prop > input$minpercent) %>% 
       ggplot(aes(Survey_Year,prop, color = Principal_Job_Label)) +
       geom_line_interactive(aes(tooltip = Principal_Job_Label)))
    
  })
}

shinyApp(ui, server)