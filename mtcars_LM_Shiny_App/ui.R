#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

show_vars <- names(mtcars)[!names(mtcars) %in% c("mpg")]

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  tags$head(
    tags$style(HTML("
                    @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
                    
                    h1 {
                    font-family: 'Lobster', cursive;
                    font-weight: 500;
                    line-height: 1.1;
                    color: red;
                    }
                    
                    "))
  ),
  
  headerPanel("Linear Models and Residuals for 'mtcars'"),
  
  sidebarPanel(
    helpText('Check the variable to include it in the prediction model.'),
    checkboxGroupInput('show_vars', 'Variables in mtcars to apply the prediction:',
                       show_vars, selected = show_vars)
  ),
  
  mainPanel(
    tabsetPanel(type = "tabs", 
                tabPanel("Linear Models", plotOutput('newLinearModel')), 
                tabPanel("HatValues", plotOutput('newHatValues')), 
                tabPanel("Betas", plotOutput('newBetas'))
    )
  )
))