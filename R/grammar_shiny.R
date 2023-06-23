# Functions for the Shiny app

#' Edit text for spelling, grammar, word count, clarity using GPT-3
#'
#' This function uses GPT-3 to assist in editing text for spelling, grammar, word count, and clarity. It is a companion function for the run grammar checker Shiny app. The function takes in the following parameters:
#'
#' @param text_to_edit: The original text that needs editing.
#' @param user_choice: A character value indicating the type of editing required. Possible values include "spelling_grammar", "word_count", or "clarity".
#' @param model_type: A character value indicating the GPT-3 model to use, these are supplied by the shiny app.
#'
#' @return Returns the edited text as a string.
#'
#' @export
check_grammar_gpt <- function(text_to_edit,user_choice, model_type){

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

  if( model_type != "gpt-3.5-turbo"){
    gpt <- openai::create_completion(
      model = model_type,
      prompt = paste(system_content,"\n",selected_text),
      max_tokens = 1000
    )

    model_response <- gpt$choices$text
  }

  if( model_type == "gpt-3.5-turbo"){
    gpt <- openai::create_chat_completion(
      model = "gpt-3.5-turbo",
      messages = list(
        list(
          "role" = "system",
          "content" = system_content
        ),
        list(
          "role" = "assistant",
          "content" = "Ok, please send the text."
        ),
        list(
          "role" = "user",
          "content" = selected_text
        )
      )
    )

    model_response <- gpt$choices$message.content
  }

  #print(gpt) error-checking
  my_string <- gsub("\n", "", model_response)

  return(my_string)
}

#' Compare Two Texts
#'
#' This function compares two texts and returns whether they are identical or a diff object from diffobj to visualize the differences in HTML. Used in conjunction with the run grammar checker Shiny app.
#'
#' @param original_text A character string representing the original text.
#' @param modified_text A character string representing the modified text.
#'
#' @return Either "identical" if the two texts are identical, or a diff object showing the differences between the two texts.
#'
#' @export
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

#' Parse RMarkdown documents into sentences or paragraphs
#' @param file a character vector of the file or path
#' @examples
#' # don't run
#' # parse_rmd()
#' @export
parse_rmd <- function(file,token_level="paragraphs"){

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
#'
#' This shiny app allows a user to manually check each sentence or paragraph in a file using OpenAI LLMs.
#'
#' The text file is split into sentences or paragraphs. The user manually goes through each and chooses whether or not to send the current text for suggested feedback.
#'
#' The prompts used for each checking option are defined in check_grammar_gpt.
#'
#' Any suggested changes returned by the model are displayed with differences between the original and modified text highlighted in the window. The returned text often has subtle changes that may be difficult to spot, hence the visualization approach.
#'
#' The suggested edits may occasionally fail to follow the instructions from the prompt. Some of the models produce very low-quality results, like ada, and babbage.
#'
#' @param path file to check
#' @param choose_token_level string "sentences" or "paragraphs", defaults to paragraphs. The document is parsed into individual sentences or paragraphs.
#' @return a shiny app is launched
#' @import shiny
#' @examples
#' # don't run during tests
#' # gptaddin::run_grammar_checker("example.rmd")
#' @export
run_grammar_checker <- function(path, choose_token_level = "paragraphs"){
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
        selectInput(inputId = 'model',
                    label = "Choose model",
                    choices = list("gpt-3.5-turbo $.002" = "gpt-3.5-turbo",
                                   "Davinci $.02" = "text-davinci-003",
                                   "Curie $.002" = "text-curie-001",
                                   "Babbage $.0005" = "text-babbage-001",
                                   "Ada $.0004" = "text-ada-001"),
                    multiple = FALSE
        ),
        sliderInput(inputId = "doc_location",
                    "Scroll Document",
                    min = 1,
                    max = length(sentences),
                    value = 1),
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
        htmlOutput(outputId = "suggested_text"),
        actionButton("copy", "Copy to clipboard")
      )
    )
  )

  server <- function(input, output, session) {

    ## Initialize Reactive variables ####
    values <- reactiveValues()

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

    # scroll through document
    observeEvent(input$doc_location, {
        counter <<- input$doc_location
        updateTextInput(session, "text", value = sentences[counter])
    })

    # submit sentence for checking to OpenAI API
    observeEvent(input$submit, {
      #print(sentences[counter])
      #print(input$options)
      #print(input$model)

      #pass text to API and get result
      values$suggestion <- check_grammar_gpt(sentences[counter],
                                      input$options,
                                      input$model)

      # find differences between original and modified text
      diff_1 <- compare_text(sentences[counter],values$suggestion)

      # display differences
      output$suggested_text <- renderUI({
        HTML(diff_1)
      })

    })

    # copy to clipboard
    observeEvent(input$copy, {
      clipr::write_clip(values$suggestion)
    })

    # exit the app
    observeEvent(input$exit, {
      stopApp()
    })
  }

  # Run the application
  shinyApp(ui = ui, server = server)
}


