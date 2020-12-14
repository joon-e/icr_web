library(shiny)

list_measures <- list("Simple agreement" = "agree", 
                      "Holsti's CR" = "holsti", 
                      "Krippendorff's Alpha" = "kripp_alpha",
                      "Cohen's Kappa" = "cohens_kappa",
                      "Fleiss' Kappa" = "fleiss_kappa",
                      "Brennan & Prediger's Kappa" = "brennan_prediger")

ui <- fluidPage(
    titlePanel(
        "Calculate Intercoder Reliability"
    ),
    sidebarLayout(
        sidebarPanel(
            
            # Dataset
            h3("Dataset"),
            fileInput("file", NULL, accept = c(".csv", ".tsv", ".sav", ".xls", ".xlsx")),
            
            selectInput("unit_id",
                        label = "Unit identifier variable",
                        ""),
            
            selectInput("coder_id",
                        label = "Coder identifier variable",
                        ""),
            
            textAreaInput("levels", "Variable levels (optional)", 
                      placeholder = 'variable_name = variable_level',
                      resize = "vertical"),
            div("Only specify variable levels other than 'nominal'."),
            
            # Options
            h3("Options"),
            
            checkboxGroupInput("measures", "Please select all ICR measures you want to calculate", 
                               list_measures),
            
            radioButtons("na", "Clean missing values", c("no", "yes")),
            
            # Calculate
            h3("Calculate"),
            actionButton("calc", "Calculate!")
        ),
        
        # Main Panel
        mainPanel(
            div(class = "instructions", includeMarkdown("instructions.md")),
            tableOutput("icr"),
            uiOutput("download_button")
        )
    ),
    
    hr(),
    includeMarkdown("footer.md")
)

server <- function(input, output, session) {
    
    # Load file
    data <- reactive({
        req(input$file)
        
        ext <- tools::file_ext(input$file$name)
        switch(ext,
               csv = vroom::vroom(input$file$datapath, delim = ","),
               tsv = vroom::vroom(input$file$datapath, delim = "\t"),
               xlsx = readxl::read_xlsx(input$file$datapath),
               xls = readxl::read_xls(input$file$datapath),
               sav = haven::read_sav(input$file$datapath),
               validate("Invalid file; Please upload a .csv, .tsv, .xlsx, .xls, or .sav file")
               )

    })
    
    # Update user input with file data
    observe({
        updateSelectInput(
            session,
            "unit_id",
            choices = names(data())
        )
    })
    
    observe({
        updateSelectInput(
            session,
            "coder_id",
            choices = names(data())
        )
    })
    
    # Calculate ICR
    icr <- eventReactive(input$calc, {
        
        # Remove instructions
        removeUI(
            selector = ".instructions"
        )
        
        # Prepare levels string
        splitted <- input$levels %>% 
            stringr::str_split(",") %>% 
            .[[1]] %>% 
            stringr::str_split(" = ")
        
        
        levels <- c()
        
        for (level in splitted) {
            new_lev <- stringr::str_squish(level[2])
            names(new_lev) <- stringr::str_squish(level[1])
            levels <- c(levels, new_lev)
        }
        
        
        
        # Calc ICR
        unit_var <- rlang::sym(input$unit_id)
        coder_var <- rlang::sym(input$coder_id)
        
        tidycomm::test_icr(data = data(), 
                           unit_var = {{ unit_var }}, 
                           coder_var = {{ coder_var }},
                           levels = levels,
                           na.omit = input$na,
                           agreement = "agree" %in% input$measures,
                           holsti = "holsti" %in% input$measures,
                           kripp_alpha = "kripp_alpha" %in% input$measures,
                           cohens_kappa = "cohens_kappa" %in% input$measures,
                           fleiss_kappa = "fleiss_kappa" %in% input$measures,
                           brennan_prediger = "brennan_prediger" %in% input$measures)
    })
    
    # Output
    output$icr <- renderTable({
       icr()
    })
    
    output$download_button <- renderUI({
        req(icr())
        downloadButton('download') 
    })
    
    output$download <- downloadHandler(
        filename = function() {
            "icr_test.csv"
        },
        content = function(file) {
            readr::write_csv(icr(), file)
        }
    )
    
}

shinyApp(ui, server)