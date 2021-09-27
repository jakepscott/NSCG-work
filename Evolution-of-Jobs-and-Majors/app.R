# Set filepath (since here doesn't place well with Shiny deploymen --------
library(here)
deployed <- T


# Load Libs and source functions ------------------------------------------
source("functions/load-libs-and-functions.R")

# Load Data ---------------------------------------------------------------
raw_data <- load_data()

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# UI ----------------------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ui <- fluidPage( 
    sidebarLayout(
        sidebarPanel(
            #Select which job or major to analyze
            selectizeInput("filter", 
                         label = "Which major to analyze:",
                         choices = raw_data$majors),
            #How many lines to show on the graph
            sliderInput("num_lines", "Number of jobs to show", 
                        min = 1, max = 10,
                        value = 5, step = 1),
            #Group by major or by job?
            selectizeInput("groupby", 
                        "What do you want to explore?",
                        choices = c("Major",
                                    "Job"))
        ),

        # Show a plot of the generated distribution
        mainPanel(
            ggiraphOutput("plot")
        )
    )
)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# UI ----------------------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
server <- function(input, output, session) {
    
    #Observe whether the group by choice changes ---------------------------------
    # This says to set the select options and slider label based on whether 
    # we are grouping by major or job
    observe({
        if (input$groupby == "Major") {
            updateSelectizeInput(session, "filter",
                                 label = "Which major to analyze:",
                                 choices = raw_data$majors)
            
            updateSliderInput(session, "num_lines",
                              "Number of jobs to show", 
                              min = 1, max = 10,
                              value = 5, step = 1 )
        }
        
        if (input$groupby == "Job") {
            updateSelectizeInput(session, "filter",
                                 label = "Which job to analyze:",
                                 choices = raw_data$jobs)
            
            updateSliderInput(session, "num_lines",
                              "Number of majors to show", 
                              min = 1, max = 10,
                              value = 5, step = 1)
        }
    })
    

# Create plot data reactive ------------------------------------------------
    # Use jobs by major data if grouping by major,
    # and use majors by job data if grouping by job
    plot_data <- reactive({
        if(input$groupby == "Major"){
            data <- raw_data$Jobs_by_Major 
        } else {
            data <- raw_data$Majors_by_Job 
        }
    })
        

# Render Plot -------------------------------------------------------------
    output$plot <- renderggiraph({
        plot <-  gen_plot(group_by = input$groupby,
                          filter = input$filter, 
                          num_lines = input$num_lines,
                          data = plot_data())
        
        ggiraph(ggobj = plot)
        })
}

# Run the application 
shinyApp(ui = ui, server = server)
