#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(UsingR)
library(ggplot2)
require(reshape2)

data(mtcars)

mtcars$vs <- factor(mtcars$vs,labels=c('V','S'))
mtcars$am <- factor(mtcars$am,labels=c('A','M'))
mtcars$cyl <- factor(mtcars$cyl)
mtcars$gear <- factor(mtcars$gear)
mtcars$carb <- factor(mtcars$carb)

fit1  <- lm(mpg ~ am, mtcars)
fitAll <- lm(mpg ~ ., mtcars)

shinyServer(function(input, output) {
  
  fitModel <- reactive({
    validate(
      need(length(input$show_vars) > 0, "Please select at least one variable")
    )
    lm(formula = as.formula(paste("mpg ~ ", paste(input$show_vars, collapse = "+"))), 
       data = mtcars)
  })
  
  hatValues <- reactive({
    validate(
      need(length(input$show_vars) > 0, "Please select at least one variable")
    )
    fit <- lm(formula = as.formula(paste("mpg ~ ", paste(input$show_vars, collapse = "+"), " -1")), 
              data = mtcars)
    melt(as.matrix(round(hatvalues(fit), 3)))
  })
  
  betas <- reactive({
    validate(
      need(length(input$show_vars) > 0, "Please select at least one variable")
    )
    fit <- lm(formula = as.formula(paste("mpg ~ ", paste(input$show_vars, collapse = "+"), " -1")), 
              data = mtcars)
    melt(round(dfbetas(fit), 3))
  })
  
  output$newLinearModel <- renderPlot({
    fitN <- fitModel()
    plot(predict(fitN), ylab = "Predictions")
    lines(predict(fitN), col = "black")
    lines(predict(fit1), col = "blue")
    lines(predict(fitAll), col = "red")
    legend("topright",
           legend=c("mpg ~ am", "mpg ~ .", "Customized"),
           col=c("blue", "red", "black"), 
           lty=1, 
           cex=0.8
    )
  })
  
  output$newHatValues <- renderPlot({
    htv <- hatValues()
    ggplot(data=htv, aes(x=Var1, y=value, group=Var2)) + 
      geom_line() + 
      theme(axis.text.x = element_text(angle=90, hjust=1, vjust=0.5)) + 
      ylab('Hatvalues') + 
      xlab('Cars') +
      theme(plot.margin = unit(c(2,0,0,0), "cm"))
  })
  
  output$newBetas <- renderPlot({
    betas <- betas()
    ggplot(data = betas, aes(x=Var1, y=value, group=Var2)) + 
      geom_line(aes(colour = Var2)) + 
      theme(axis.text.x = element_text(angle=90, hjust=1, vjust=0.5)) + 
      ylab('DfBetas') + 
      xlab('Cars') +
      theme(plot.margin = unit(c(2,0,0,0), "cm"))
  })
})