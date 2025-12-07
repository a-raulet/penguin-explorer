library(shiny)
library(httr2)
library(log4r)

api_url <- Sys.getenv("API_URL", "http://127.0.0.1:8080/predict")
log <- logger()

ui <- fluidPage(
  titlePanel("Penguin Mass Predictor"),

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
  info(log, paste("App Started, API URL:", api_url))

  vals <- reactive(
    list(
      bill_length_mm = input$bill_length,
      species_Chinstrap = input$species == "Chinstrap",
      species_Gentoo = input$species == "Gentoo",
      sex_male = input$sex == "Male"
    )
  )

  pred <- eventReactive(
    input$predict,
    {
      info(log, "Prediction requested")

      tryCatch({
        r <- request(api_url) |>
          req_body_json(list(vals())) |>
          req_perform()
        info(log, "Prediction returned")

        if (resp_is_error(r)) {
          error(log, paste("HTTP Error:", resp_status(r)))
          return(list(predict = list(NA)))
        }

        resp_body_json(r)
      }, error = function(e) {
        error(log, paste("Request failed:", e$message))
        return(list(predict = list(NA)))
      })
    },
    ignoreInit = TRUE
  )

  output$pred <- renderText({
    result <- pred()$predict[[1]]
    if (is.na(result)) {
      "Erreur: API indisponible"
    } else {
      as.character(round(result))
    }
  })

  output$vals <- renderPrint(vals())
}

shinyApp(ui = ui, server = server)
