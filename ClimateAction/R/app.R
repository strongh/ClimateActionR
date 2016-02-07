#' View Climate
#'
#' Starts a Shiny app for viewing climate data.
#' @param start
#' @param end
#' @keywords download
#' @export
#' @examples
#' shiny_viewer()
shiny_viewer <- function() {
  require(shiny)
  require(ggplot2)
  require(dplyr)
  require(rdrop2)
  data.files <- drop_dir("/ClimateActionRData") %>% filter(mime_type=="text/csv")
  shinyApp(
    ui = fluidPage(
      titlePanel("Climate Action Data Viewer"),
      
      sidebarLayout(
        sidebarPanel(
          helpText("Examine spatial climate data."),
          selectInput("dataset", "Data:", data.files$path),
          "Code:",
          verbatimTextOutput("example.code")
        ),
        
        mainPanel(
          tabsetPanel(type = "tabs",
                      tabPanel("Time Series",
                               plotOutput("time.series.plot")
                            ),
                      tabPanel("Table",
                               dataTableOutput("table")),
                      tabPanel("Map",
                               plotOutput("map"))
                      
          )   )
      )
    ),
    server = function(input, output) {
      output$table <- renderDataTable({
        df <- drop_read_csv(input$dataset)
        df
      })
      output$time.series.plot <- renderPlot({
        df <- drop_read_csv(input$dataset) %>% filter(state=="California")
        if("year" %in% names(df))
          ggplot(df, aes_string("year", names(df)[-ncol(df)])) + geom_line()
      })
      output$map <- renderPlot({
        df <- drop_read_csv(input$dataset)
        if(all(c("lon", "lat") %in% names(df)))
          ggplot(df, aes(lon, lat)) + geom_raster(aes_string(fill=names(df)[ncol(df)]))
      })
      output$example.code <- renderText({
        paste0("R> ", "drop_read_csv(\"", input$dataset, "\")")
      })
    }
  )
}

shiny_viewer()