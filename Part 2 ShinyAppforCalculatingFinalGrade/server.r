library(shiny)

shinyServer(
        function(input, output) {
                
                output$finalexampercent <- renderPrint((input$id5*10 - (input$id1*1.5) - (input$id2*1.5) - (input$id3*1.5) - (input$id4*3))/2.5)
                
                output$predictedfinalexam <- renderPrint(0 + 0.28875*(input$id1)  + 0.20718*(input$id2) + 0.43496*(input$id3))

        }
                          
)

