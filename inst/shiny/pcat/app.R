library(shiny)
library(pcatR)

ui <- fluidPage(
  titlePanel("pcatR analysis dashboard"),
  sidebarLayout(
    sidebarPanel(
      fileInput(
        "file",
        "Upload pCAT CSV",
        accept = c(".csv", "text/csv", "text/comma-separated-values")
      ),
      selectInput(
        "layout",
        "Input layout",
        choices = c("Auto-detect" = "auto", "Long" = "long", "Wide" = "wide"),
        selected = "auto"
      ),
      checkboxInput("complete", "Require all 14 items", value = TRUE),
      selectizeInput(
        "group",
        "Profile and summary grouping",
        choices = NULL,
        multiple = TRUE
      ),
      downloadButton("template", "Download long template"),
      downloadButton("classified", "Download classified data"),
      downloadButton("summary", "Download item summary"),
      downloadButton("action", "Download action plan"),
      tags$hr(),
      helpText(
        "Use non-sensitive study identifiers only. This local dashboard is an",
        "analysis interface, not a secure survey or protected-health-information platform."
      )
    ),
    mainPanel(
      tabsetPanel(
        tabPanel(
          "Validation",
          verbatimTextOutput("validation"),
          tableOutput("issues")
        ),
        tabPanel("Profile", plotOutput("profile", height = "1050px")),
        tabPanel("Item summary", tableOutput("summary_table")),
        tabPanel("Consensus", tableOutput("consensus_table")),
        tabPanel("Action plan", tableOutput("action_table")),
        tabPanel("Classified data", tableOutput("preview"))
      )
    )
  )
)

server <- function(input, output, session) {
  raw_data <- reactive({
    req(input$file)
    pcat_read_csv(
      input$file$datapath,
      layout = input$layout
    )
  })

  observeEvent(raw_data(), {
    choices <- intersect(
      c("project_id", "site_id", "team_id", "role", "timepoint"),
      names(raw_data())
    )
    selected <- intersect(c("site_id", "timepoint"), choices)
    updateSelectizeInput(
      session,
      "group",
      choices = choices,
      selected = selected,
      server = TRUE
    )
  })

  analysis <- reactive({
    pcat_analyse(
      raw_data(),
      group_vars = input$group,
      require_complete = isTRUE(input$complete),
      validation_action = "none"
    )
  })

  output$validation <- renderPrint({
    print(analysis()$validation)
  })

  output$issues <- renderTable({
    issues <- pcat_validation_issues(analysis()$validation)
    if (nrow(issues) == 0L) {
      data.frame(status = "No validation issues detected.")
    } else {
      utils::head(issues, 100L)
    }
  }, striped = TRUE, bordered = TRUE)

  output$profile <- renderPlot({
    plot_pcat_profile(
      analysis()$classified,
      group_vars = input$group,
      label = "cfir_original_construct",
      facet_ncol = if (length(input$group) == 0L) NULL else 1L,
      label_width = 30L
    )
  }, res = 110)

  output$summary_table <- renderTable({
    utils::head(analysis()$summary, 100L)
  }, striped = TRUE, bordered = TRUE)

  output$consensus_table <- renderTable({
    utils::head(analysis()$consensus, 100L)
  }, striped = TRUE, bordered = TRUE)

  output$action_table <- renderTable({
    plan <- analysis()$action_plan
    if (is.null(plan) || nrow(plan) == 0L) {
      data.frame(status = "No items met the default action-plan thresholds.")
    } else {
      utils::head(plan, 100L)
    }
  }, striped = TRUE, bordered = TRUE)

  output$preview <- renderTable({
    utils::head(analysis()$classified, 100L)
  }, striped = TRUE, bordered = TRUE)

  output$template <- downloadHandler(
    filename = function() "pcat_long_template.csv",
    content = function(file) {
      utils::write.csv(
        pcat_template("long"),
        file,
        row.names = FALSE,
        na = ""
      )
    }
  )

  output$classified <- downloadHandler(
    filename = function() "pcat_classified.csv",
    content = function(file) {
      utils::write.csv(
        analysis()$classified,
        file,
        row.names = FALSE,
        na = ""
      )
    }
  )

  output$summary <- downloadHandler(
    filename = function() "pcat_item_summary.csv",
    content = function(file) {
      utils::write.csv(
        analysis()$summary,
        file,
        row.names = FALSE,
        na = ""
      )
    }
  )

  output$action <- downloadHandler(
    filename = function() "pcat_action_plan.csv",
    content = function(file) {
      plan <- analysis()$action_plan
      if (is.null(plan)) plan <- data.frame()
      utils::write.csv(plan, file, row.names = FALSE, na = "")
    }
  )
}

shinyApp(ui, server)
