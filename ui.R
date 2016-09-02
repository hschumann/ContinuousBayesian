## ui.R
## the user interface for the 
## Continuous Bayes' applet for varying k's

shinyUI(fluidPage(
  ## App Title
  h1("CONTINUOUS BAYESIAN STATISTICS"),
  h3("With Improper Prior Distributions"),
  #h3("Prior Distributions Related to 1 / theta^k"),
  
  ## sidebar panel for the input values
  sidebarPanel(
    ## panel to set prior parameters for Uniform dist.
    h4("Improper Prior Distribution"),
    ## numeric input to decide k (prior = 1/theta^k)
    numericInput("k",label = "k",value = 0),
    br(),
    
    ## input for the sample data
    fileInput('sample_data','Sample Data',
              accept = c(
                'text/csv',
                'text/comma-separated-values',
                'text/tab-separated-values',
                'text/plain',
                '.csv',
                '.tsv')
    ),
    br(),
    
    radioButtons('cred.int','Size of HPD Interval',
                 c("90%" = '.90','95%' = '.95','99%' = '.99')),
    h6("Made by Hans Schumann")
  ),
  mainPanel(
    plotOutput("all_plots"),
    textOutput("interval"),
    textOutput("value")
  )
))



