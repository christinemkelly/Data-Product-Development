library(shiny)
shinyUI(pageWithSidebar (
        headerPanel(
                h2("Calculating A Final Exam Score", align='center')), 
        
        sidebarPanel(
                p('This app allows you to determine the grade you need on the
                final exam in general chemistry to achieve your desired grade in the class.'),
br(), 

                h5('Enter your exam and homework scores as percentages:', align='center', style ='color:darkblue'),
                
                
                numericInput('id1', 'Exam I (%)', 0, min=0, max=100),
                numericInput('id2', 'Exam II (%)', 0, min=0, max=100),
                numericInput('id3', 'Exam III (%)', 0, min=0, max=100),
                numericInput('id4', 'Homework (%)', 0, min=0, max=100),

br(),

                h5('Now select your desired final course percentage:', align='center', style ='color:darkblue'),
                
                sliderInput('id5', '', value = 0, min = 0, max = 100, step = 0.5),
                

                h5('Results and self-assessment questions are shown to the right =>', align='center', style ='color:darkblue')
         ),
        
        mainPanel (
br(),
br(),
br(),
br(),
br(),
                h4('YOUR CALCULATED FINAL EXAM SCORE (%)', align='center', style ='color:darkgreen'),
                h5('For the final exam you need the percentage shown below in order to achieve your 
                        desired course outcome:'),
                
                verbatimTextOutput('finalexampercent'),
                
                h5('Based on this score:'),
                
                h5('1.  How much effort do you need to put into the final exam? More than you thought? 
                   Less? Use this as a guide as to how to spend your study time amongst all
                   of your upcoming finals.'),
                
                
                h5('2. Is it mathematically possible to achieve this score? A score of more 
                   than 100% on the final is just not possible! So no matter how hard you plan
                   to work and no matter how strong your intentions to get the grade
                   you want, if you need more than 100% on the final it just will not happen. Sorry 
                   but it is better that you see this now rather than later :)'),
                
br(),
br(),
br(),
                h4('YOUR PREDICTED FINAL EXAM SCORE (%)', align='center', style ='color:darkgreen'),
                h5('Based on your grades in this class, your predicted final exam score 
                (+/-1.16% at the 95% confidence level) is:'),
                
                verbatimTextOutput('predictedfinalexam'),
                
                
                h5('1. How does your predicted score compare to your exam averages? Students who 
                score higher on the final exam than their average on individual exams do so by 
                about 5.48 points. Students who score lower on the final exam than their 
                average on individual exam do so by about 10.1 points. The later scenario is not 
                uncommon: the final exam is cumulative which means a lot of material to remember. 
                And final exams are stressful: students are burned out by the end of 
                the semester. Keep these points in in mind as you prepare for the final.'),

                h5('2. Is the predicted value less than the final exam
                score that you need to get the desired course grade? If so, how likely is it that you 
                can score higher than the predicted score? Be careful in thinking that
                "If I work hard enough I can do this!" You may need to adjust your desired final 
                course percent expectation until you reach a final exam score that is in line with
                the predicted value and therefore achievable.')
                
                )
        ))
