## server.R
## this is the background for the
## Continuous Bayes' applet for varying k's

library(shiny)

shinyServer(function(input,output) {
  ## this code will produce the plots for the applet
  output$all_plots <- renderPlot({
    ## create template for 4 plots and set the window size
    par(mfrow = c(2,2))
    op <- par(mar = c(5,7,4,2) + 0.1)
    
    ## plotting the sample data
    sample <- eventReactive(input$sample_data, {
      inFile <- input$sample_data
      if (is.null(inFile)) {
        return (NULL)
      }
      read.csv(inFile$datapath,header = T,sep = ',')
    })
    
    x <- seq(0,2*max(sample()$y),length = 2500)
    hx1 <- 1 / (x^input$k)
    
    ## plotting prior
    plot(x,hx1,xlab = expression(theta),ylab = '',
         main = paste0("Prior Distribution with k = ",input$k),
         col = 'midnightblue',
         type = 'l',lwd = 2.5,las = 2)
    mtext(text='Probability', side=2, line=4)
    
    hist(sample()$y,xlab = 'y',
         main = 'Distribution of Sample',col = 'forestgreen')
    
    y <- seq(0,2*max(sample()$y),length = 2500)
    m <- max(sample()$y)
    likelihood <- (m / y)^length(sample()$y)
    likelihood[which(likelihood > 1)] <- 0
    
    posterior <- hx1 * likelihood
    names(posterior) <- y
    val <- ((input$k + length(sample()$y) - 1)/(input$k + length(sample()$y) - 2))*max(sample()$y)
    #browser()
    posterior <- posterior / sum(posterior[-1])
    plot(posterior,
         main = 'Posterior Distribution and Bayes Estimate',
         xlab = expression(theta),xaxt = 'n',
         ylab = '',
         col = 'darkorange',las = 2)
    mtext(text='Probability', side=2, line=4)
    axis(1,at = seq(0,2500,length = 9),las = 2,
         labels = round(seq(0,2*max(sample()$y),length = 9),1))
    abline(v = val*1250 / max(sample()$y),col = 'dodgerblue',lwd = 2.5)
  })
  
  output$interval <- renderText({
    samp <- eventReactive(input$sample_data, {
      inFile <- input$sample_data
      if (is.null(inFile)) {
        return (NULL)
      } else {
        read.csv(inFile$datapath,header = T,sep = ',')
      }
    })
    if (!is.null(samp())) {
      lower <- max(samp()$y)
      upper <- (1 - as.numeric(input$cred.int))^((-1)/(input$k + length(samp()$y) - 1))*max(samp()$y)
      paste0("Highest Probability Density Interval: ",lower," to ",round(upper,3))
    } else {
      paste0("")
    }
  })
  
  output$value <- renderText({
    samp <- eventReactive(input$sample_data, {
      inFile <- input$sample_data
      if (is.null(inFile)) {
        return (NULL)
      } else {
        read.csv(inFile$datapath,header = T,sep = ',')
      }
    })
    if (!is.null(samp())) {
      val <- ((input$k + length(samp()$y) - 1)/(input$k + length(samp()$y) - 2))*max(samp()$y)
      paste0("Bayes Estimate: ",round(val,3))
    } else {
      paste0("")
    }
  })
})

