library(shiny)

api_url <- "http://127.0.0.1:8080/predict"
log <- log4r::logger()

ui <- fluidPage(
  titlePanel("Penguin Mass Predictor"),

  # Model input values
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        "bill_length",
        "Bill Length (mm)",
        min = 30,
        max = 60,
        value = 45,
        step = 0.1
      ),
      selectInput(
        "sex",
        "Sex",
        c("Male", "Female")
      ),
      selectInput(
        "species",
        "Species",
        c("Adelie", "Chinstrap", "Gentoo")
      ),
      # Get model predictions
      actionButton(
        "predict",
        "Predict"
      )
    ),

    mainPanel(
      h2("Penguin Parameters"),
      verbatimTextOutput("vals"),
      h2("Predicted Penguin Mass (g)"),
      textOutput("pred")
    )
  )
)

server <- function(input, output) {
  log4r::info(log, "App Started")
  # Input params
  vals <- reactive(
    list(
      bill_length_mm = input$bill_length,
      species_Chinstrap = input$species == "Chinstrap",
      species_Gentoo = input$species == "Gentoo",
      sex_male = input$sex == "Male"
    )
  )

  # Fetch prediction from API
  pred <- eventReactive(
    input$predict,
    {
      log4r::info(log, "Prediction requested")
      r <- httr2::request(api_url) |>
        httr2::req_body_json(list(vals())) |>
        httr2::req_perform()
      log4r::info(log, "Prediction returned")
      
      if (httr2::resp_is_error(r)) {
        log4r::error(log, paste("HTTP Error"))
      }
      
        httr2::resp_body_json(r)

    },
    ignoreInit = TRUE
    
  )

  # Render to UI
  output$pred <- renderText(pred()$predict[[1]])
  output$vals <- renderPrint(vals())
}

# Run the application
shinyApp(ui = ui, server = server)
