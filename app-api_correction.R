library(shiny)

api_url <- "http://127.0.0.1:8080/predict"

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
  # Input params
  vals <- reactive({
    list(
      bill_length_mm = input$bill_length,
      species_Chinstrap = input$species == "Chinstrap",
      species_Gentoo = input$species == "Gentoo",
      sex_male = input$sex == "Male"
    )
  })
  
  # Fetch prediction from API
  pred <- eventReactive(input$predict, {
    # Wrap vals() in a list to create a JSON array
    req <- httr2::request(api_url) |>
      httr2::req_body_json(list(vals())) |> ## CHANGEMENT ICI !!
      httr2::req_perform()
    
    # Parse the response
    httr2::resp_body_json(req)
  }, ignoreInit = TRUE)
  
  # Render to UI
  output$pred <- renderText({
    tryCatch({
      pred()$predict[[1]]
    }, error = function(e) {
      paste("Error:", e$message)
    })
  })
  ## CHANGEMENT ICI
  output$vals <- renderPrint({
    jsonlite::toJSON(vals(), pretty = TRUE)
  })
}


# Run the application
shinyApp(ui = ui, server = server)