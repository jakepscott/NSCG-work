

plot_function<- function(group_by, filter, 
                         color, num_lines = 5, data){
  windowsFonts(`Roboto Condensed`=windowsFont("Roboto Condensed"))
  if (group_by == "Major") {
    
    #Find the top num_lines jobs for the given major over
    # all periods
    top_5 <- data %>%
      filter(Major_Label == filter) %>% 
      group_by(Principal_Job) %>% 
      summarise(mean = mean(percent,na.rm = T)) %>% 
      arrange(desc(mean)) %>% 
      head(num_lines)
    
    #Filter data to just the top 5 most common jobs for given major
    data <- data %>% 
      filter(Major_Label == filter) %>%
      filter(Principal_Job %in% top_5$Principal_Job)
    
  } else {
    #Find the top num_lines majors for the given job over
    # all periods
    data <- Majors_by_Job %>% 
      filter(Job_Label == filter) %>% 
      group_by(Major) %>% 
      summarise(mean = mean(percent,na.rm = T)) %>% 
      arrange(desc(mean)) %>% 
      head(num_lines)
    
    #Filter data to just the top 5 most common majors for given job
    data <- data %>% 
      filter(Job_Label == filter) %>%
      filter(Major %in% top_5$Major)
    
  }
  
  if (group_by == "Major") {
    plot_title <- glue("Most popular jobs for those who studied *{str_to_lower(filter)}*")
  } else {
    plot_title <- glue("Most popular fields of study for those who work as a *{str_to_lower(filter)}*") 
  }
  
  
  data %>% 
    #survey year on the x axis, percent on the y axis, and 
    # color the lines based on the variable selected by the user
    ggplot(aes(Survey_Year,percent, color = str_wrap(!!as.symbol(color), width = 40))) +
    geom_line() +
    geom_point_interactive(aes(tooltip = !!as.symbol(color))) +
    scale_x_continuous(breaks = c(2003,2010,2013,2015,2017)) +
    scale_y_continuous(labels = function(y){glue("{y}%")}) +
    guides(color = guide_legend(ncol = 2)) +
    labs(y = NULL,
         x = "Survey Year",
         title = plot_title) +
    theme_minimal(base_family = "Roboto Condensed", 
                  base_size = 12) + 
    theme(legend.position = "bottom",
          legend.title = element_blank(),
          plot.title.position = "plot",
          plot.title = element_markdown(plot_title))
}

plot_function(group_by = "Principal_Job", 
              filter = "Economists", 
              color = "Major_Label", 
              num_lines = 5, 
              data = data$Majors_by_Job)
