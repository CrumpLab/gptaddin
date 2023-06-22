check_grammar_gpt <- function(text_to_edit,user_choice){

  # get selected text
  selected_text <- text_to_edit

  if( user_choice == "spelling_grammar"){
    system_content <- "You are an editorial writing assistant. Edit the text for spelling and grammar. Don't change the meaning of the words."
  }

  if( user_choice == "word_count"){
    system_content <- "You are an editorial writing assistant. Edit the text to reduce word count without changing the meaning."
  }

  if( user_choice == "clarity"){
    system_content <- "You are an editorial writing assistant. Edit the text to improve clarity and flow."
  }

  gpt <- openai::create_completion(
    model = "text-davinci-003",
    prompt = paste(system_content,"\n",selected_text),
    max_tokens = 2024,

  )

  #print(gpt) error-checking

  return(gpt$choices$text)
}

compare_text <- function(original_text, modified_text) {
  if (identical(original_text, modified_text)) {
    return("identical")
  } else {
      as.character(
        diffobj::diffChr(original_text, modified_text, format="html",
                           style=list(html.output="diff.w.style"))
      )
  }
}

# These functions were inspired by, and rewritten from https://github.com/jasdumas/gramr

#--------------------------------
# Functions for the Shiny app

#' Parse RMarkdown documents into sentences or paragraphs
#' @param file a character vector of the file or path
#' @examples
#' # don't run
#' # parse_rmd()
#' @export
parse_rmd <- function(file,token_level="sentences"){

  # Read in the R Markdown file
  rmd_file <- readLines(file)

  if(token_level == "sentences"){
    # Parse the Rmd file into individual sentences
    sentences <- unlist(tokenizers::tokenize_sentences(rmd_file))
  }

  if(token_level == "paragraphs"){
    # Parse the Rmd file into individual sentences
    sentences <- unlist(tokenizers::tokenize_paragraphs(rmd_file))
  }

  sentences

}


#' Start grammar checker shiny application
#' Start the grammar checker.
#' @param path the intended filepath
#' @param choose_token_level string "sentences" or "paragraphs", defaults to sentences
#' @return a shiny app is launched
#' @import shiny
#' @examples
#' # don't run during tests
#' # gptaddin::run_grammar_checker("example.rmd")
#' @export
run_grammar_checker <- function(path, choose_token_level = "sentences"){
  sentences <- parse_rmd(path, choose_token_level)
  counter <- 1

  ui <- fluidPage(
    # Application title
    titlePanel(
      "GPT Grammar checker"
    ),
    sidebarLayout(
      sidebarPanel(
        selectInput(inputId = 'options',
                           label = "Choose prompt",
                           choices = list("Basic Spelling and grammar" = "spelling_grammar",
                                            "Reduced word count" = "word_count",
                                            "Improved clarity" = "clarity"),
                            multiple = FALSE
        ),
        actionButton("nextS", "Next"),
        actionButton("submit","Submit"),
        actionButton("backS", "Back"),
        actionButton("exit", "Finish")
      ),
      mainPanel(
        textAreaInput(inputId  = 'text',
                      label  = 'Text to Check',
                      value  = sentences[1],
                      height = 150,
                      width = 500,
                      resize = "both"),
        h3("Suggestion"),
        htmlOutput(outputId = "text")
      )
    )
  )

  server <- function(input, output, session) {

    # go to next sentence
    observeEvent(input$nextS, {
      if( counter < length(sentences)){
        counter <<- counter + 1
        updateTextInput(session, "text", value = sentences[counter])
      }
    })

    # go to previous sentence
    observeEvent(input$backS, {
      if( counter > 1){
        counter <<- counter - 1
        updateTextInput(session, "text", value = sentences[counter])
      }
    })

    # submit sentence for checking to OpenAI API
    observeEvent(input$submit, {
      #print(input$options)
      output$text <- renderText({
        "Submitting text..."
      })
      suggestion <- check_grammar_gpt(sentences[counter],input$options)
      diff <- compare_text(sentences[counter],suggestion)
      output$text <- renderUI({
        HTML(diff)
      })
    })

    # exit the app
    observeEvent(input$exit, {
      #text_df[ text_df$line_num == check_df$line_num[counter], "text"] <- input$text
      #writeLines(text_df$text, path)
      stopApp()
    })
  }

  # Run the application
  shinyApp(ui = ui, server = server)
}


