
#' Get suggested line edits
#'
#' This is an RStudio addin function that should become available after the package is installed.
#'
#' Highlight text in an editor window while using Rstudio, then select the addin from the drop-down menu.
#'
#' This function sends the selected text to a gpt-3.5-turbo chat model. The system prompt is:
#'
#' You are an editorial writing assistant. Your task is to edit the content you receive for improved clarity, flow, and reduced word count.
#'
#' The model receives the highlighted text, generates a response following the prompt, and returns the new suggested text to the console.
#'
#' @return string to console
#' @export
#'
line_editor <- function(){


  # get selected text
  selected_text <- rstudioapi::selectionGet()

  message("Submitting query...")

  # run the api call to openai
  gpt <- openai::create_chat_completion(
    model = "gpt-3.5-turbo",
    messages = list(
      list(
        "role" = "system",
        "content" = "You are an editorial writing assistant. Your task is to edit the content you receive for improved clarity, flow, and reduced word count. You should respect the original style of the input text and use an active voice."
      ),
      list(
        "role" = "user",
        "content" = selected_text$value
      )
    )
  )

  # print the results to the console
  print(cat(gpt$choices$message.content))
}

#' Get suggested line edits
#'
#' This is an RStudio addin function that should become available after the package is installed.
#'
#' Highlight text in an editor window while using Rstudio, then select the addin from the drop-down menu. Allows a selection of different editing prompts from the console before sending.
#'
#' This function sends the selected text to a gpt-3.5-turbo chat model. The system prompt is:
#'
#' You are an editorial writing assistant. Your task is to edit the content you receive for improved clarity, flow, and reduced word count.
#'
#' The model receives the highlighted text, generates a response following the prompt, and returns the new suggested text to the console.
#'
#' @return string to console
#' @export
#'
gpt_edit <- function(){

  # get selected text
  selected_text <- rstudioapi::selectionGet()

  user_choice <- menu(
    choices = c(
      "Basic spelling and grammar",
      "Flow, reduced word count",
      "Compress text",
      "Write custom prompt: "
    ),
    title = "Choose editing prompt"
  )

  if( user_choice == 1){
    system_content <- "You are an editorial writing assistant. Edit the text for spelling and grammar. Don't change the meaning or the words."
  }

  if( user_choice == 2){
    system_content <- "You are an editorial writing assistant. Your task is to edit the content you receive for improved clarity, flow, and reduced word count. You should respect the original style of the input text and use an active voice."
  }

  if( user_choice == 3){
    system_content <- "You are a text compressor. Compress the meaning of the text into as few words as possible, make it so that you can understand the text even if it is not readable to a human."
  }

  if( user_choice == 4){
    system_content <- readline(prompt = "Enter your prompt")
  }

  # run the api call to openai
  gpt <- openai::create_chat_completion(
    model = "gpt-3.5-turbo",
    messages = list(
      list(
        "role" = "system",
        "content" = system_content
      ),
      list(
        "role" = "user",
        "content" = selected_text$value
      )
    )
  )

  # print the results to the console
  print(cat(gpt$choices$message.content))
}

#' Get suggested line edits with markdown flagged changes
#'
#' This is an RStudio addin function that should become available after the package is installed.
#'
#' Highlight text in an editor window while using Rstudio, then select the addin from the drop-down menu.
#'
#' This function sends the selected text to a gpt-3.5-turbo chat model. The system prompt is:
#'
#' You are an editorial writing assistant. Your task is to edit the content you receive for improved clarity, flow, and reduced word count. You should respect the original style of the input text and use an active voice. Please return the edited text using markdown syntax to highlight all the changed wording. Specifically, put bold all of the changed words or phrases that are different from the original text.
#'
#' The model receives the highlighted text, generates a response following the prompt, and returns the new suggested text to the console.
#'
#' @return string to console
#' @export
#'
line_editor_markdown <- function(){


  # get selected text
  selected_text <- rstudioapi::selectionGet()

  message("Submitting query...")

  # run the api call to openai
  gpt <- openai::create_chat_completion(
    model = "gpt-3.5-turbo",
    messages = list(
      list(
        "role" = "system",
        "content" = "You are an editorial writing assistant. Your task is to edit the content you receive for improved clarity, flow, and reduced word count. You should respect the original style of the input text and use an active voice. Please return the edited text using markdown syntax to bold any of the suggested changes."
      ),
      list(
        "role" = "user",
        "content" = selected_text$value
      )
    )
  )

  # print the results to the console
  print(cat(gpt$choices$message.content))
}



#' Convert point form to longform prose
#'
#' This is an RStudio addin function that should become available after the package is installed.
#'
#' Highlight point form text in an editor window while using Rstudio, then select the addin from the drop-down menu.
#'
#' This function sends the selected text to a gpt-3.5-turbo chat model. The system prompt is:
#'
#' You are a writing assistant. Your task is to take point form notes and convert them into longform prose. Please write in a straightforward and clear manner. The user prompt will contain point form notes.
#'
#' The model receives the highlighted text, generates a response following the prompt, and returns the new suggested text to the console.
#'
#' @return string to console
#' @export
#'
points_to_prose <- function(){


  # get selected text
  selected_text <- rstudioapi::selectionGet()

  message("Submitting query...")

  # run the api call to openai
  gpt <- openai::create_chat_completion(
    model = "gpt-3.5-turbo",
    messages = list(
      list(
        "role" = "system",
        "content" = "You are a writing assistant. Your task is to take point form notes and convert them into longform prose. Please write in a straightforward and clear manner. The user prompt will contain point form notes."
      ),
      list(
        "role" = "user",
        "content" = selected_text$value
      )
    )
  )

  # print the results to the console
  print(cat(gpt$choices$message.content))
}


#' summarize text into a series of points
#'
#' This is an RStudio addin function that should become available after the package is installed.
#'
#' Highlight text in an editor window while using Rstudio, then select the addin from the drop-down menu.
#'
#' This function sends the selected text to a gpt-3.5-turbo chat model. The system prompt is:
#'
#' You are a writing assistant. Your task is to summarize input text into clear pointform notes.
#'
#' The model receives the highlighted text, generates a response following the prompt, and returns the new suggested text to the console.
#'
#' @return string to console
#' @export
summarize_main_points <- function(){

  # get selected text
  selected_text <- rstudioapi::selectionGet()

  message("Submitting query...")

  # run the api call to openai
  gpt <- openai::create_chat_completion(
    model = "gpt-3.5-turbo",
    messages = list(
      list(
        "role" = "system",
        "content" = "You are a writing assistant. Your task is to summarize input text into clear pointform notes."
      ),
      list(
        "role" = "user",
        "content" = selected_text$value
      )
    )
  )

  # print the results to the console
  print(cat(gpt$choices$message.content))
}

#' Send highlighted text as completion prompt to ada
#'
#' This is an RStudio addin function that should become available after the package is installed.
#'
#' Highlight text in an editor window while using Rstudio, then select the addin from the drop-down menu.
#'
#' This function sends the selected text to an ada model
#'
#' The model receives the highlighted text, generates a completion prompt, and returns the generated text to the console.
#'
#' @return string to console
#' @export
completion_ada <- function(){

  # get selected text
  selected_text <- rstudioapi::selectionGet()

  message("Submitting query...")
  message("Your prompt was")
  message(selected_text)

  # run the api call to openai
  gpt <- openai::create_completion(
    model = "text-ada-001",
    prompt = selected_text$value,
    max_tokens = 256,

  )

  # print the results to the console
  print(cat(gpt$choices$text))

}

#' Send highlighted text as completion prompt to davinci
#'
#' This is an RStudio addin function that should become available after the package is installed.
#'
#' Highlight text in an editor window while using Rstudio, then select the addin from the drop-down menu.
#'
#' This function sends the selected text to a davinci model
#'
#' The model receives the highlighted text, generates a completion prompt, and returns the generated text to the console.
#'
#' @return string to console
#' @export
completion_davinci <- function(){

  # get selected text
  selected_text <- rstudioapi::selectionGet()

  message("Submitting query...")
  message("Your prompt was")
  message(selected_text)

  # run the api call to openai
  gpt <- openai::create_completion(
    model = "text-davinci-003",
    prompt = selected_text$value,
    max_tokens = 256,

  )

  # print the results to the console
  print(cat(gpt$choices$text))

}


#' Send highlighted text as a completion prompt to gpt-3.5-turbo
#'
#' This is an RStudio addin function that should become available after the package is installed.
#'
#' Highlight text in an editor window while using Rstudio, then select the addin from the drop-down menu.
#'
#' This function sends the selected text to a gpt-3.5-turbo model
#'
#' The model receives the highlighted text, generates a completion prompt, and returns the generated text to the console.
#'
#' @return string to console
#' @export
completion_chat <- function(){

  # get selected text
  selected_text <- rstudioapi::selectionGet()

  message("Submitting query...")

  # run the api call to openai
  gpt <- openai::create_chat_completion(
    model = "gpt-3.5-turbo",
    messages = list(
      list(
        "role" = "system",
        "content" = "You are a helpful assistant."
      ),
      list(
        "role" = "user",
        "content" = selected_text$value
      )
    )
  )

  # print the results to the console
  print(cat(gpt$choices$message.content))
}

#' Send highlighted text to gpt-3.5-turbo output to doc
#'
#' This is an RStudio addin function that should become available after the package is installed.
#'
#' Highlight text in an editor window while using Rstudio, then select the addin from the drop-down menu.
#'
#' This function sends the selected text to a gpt-3.5-turbo model and returns the output to the document, not the console.
#'
#' The selected text is replaced with the original text, a new line, and the response from the model.
#'
#' @return string to console
#' @export
chat_to_doc <- function(){

  # get document id and selection range
  active_context <- rstudioapi::getActiveDocumentContext()
  #print(active_context)

  # get selected text
  selected_text <- rstudioapi::selectionGet()

  message("Submitting query...")

  #run the api call to openai
  gpt <- openai::create_chat_completion(
    model = "gpt-3.5-turbo",
    messages = list(
      list(
        "role" = "system",
        "content" = "You are a helpful assistant."
      ),
      list(
        "role" = "user",
        "content" = selected_text$value
      )
    )
  )

  # insert original selection plus response back into document
  new_text <- gpt$choices$message.content
  insert_text <- paste(selected_text,"\n", new_text, sep="\n")

  rstudioapi::insertText(location = active_context$selection[[1]]$range,
                         text = insert_text,
                         id = active_context$id)
}

#' Start a continuous chat with message history
#'
#' Run this in the console
#'
#' Very basic right now, no error checking. Chat history is preserved in my_chat which is returned to the global environment. Running this function initializes my_chat, and deletes anything that was in there.
#'
#' @return list called my_chat to the global environment
#'
#' @export
start_chat <- function(){

  # make list to save results
  my_chat <<- list()

  # initial prompt
  my_chat$message <<- list(
    list("role" = "system",
         "content" = "You are a helpful assistant.")
  )

  # send prompt
  gpt <- openai::create_chat_completion(
    model = "gpt-3.5-turbo",
    messages = my_chat$message
  )

  #store results
  my_chat$history[[1]] <<- gpt
  my_chat$message[[length(my_chat$message)+1]] <<- list(
    "role" = gpt$choices$message.role,
    "content" = gpt$choices$message.content
  )

  # print response to console
  print(cat(gpt$choices$message.content))

}

#' Continue a chat with message history
#'
#' To be used in combination with start_chat
#'
#' Select any text in the editor then run this addin.
#'
#' The selected text is combined with the existing message history and sent as a prompt to OpenAI.
#'
#' @return string to the editor window
#'
#' @export
continue_chat <- function(){

  # get document id and selection range
  active_context <- rstudioapi::getActiveDocumentContext()
  #print(active_context)

  # get selected text
  selected_text <- rstudioapi::selectionGet()

  my_chat$message[[length(my_chat$message)+1]] <<- list(
    "role" = "user",
    "content" = selected_text$value
  )

  # send prompt
  gpt <- openai::create_chat_completion(
    model = "gpt-3.5-turbo",
    messages = my_chat$message
  )

  #store results
  my_chat$history[[length(my_chat$history)+1]] <<- gpt
  my_chat$message[[length(my_chat$message)+1]] <<- list(
    "role" = gpt$choices$message.role,
    "content" = gpt$choices$message.content
  )

  print(paste("Prompt tokens used: ",my_chat$history[[length(my_chat$history)]]$usage$prompt_tokens))

  new_text <- gpt$choices$message.content
  insert_text <- paste(selected_text,"\n", new_text, sep="\n")

  rstudioapi::insertText(location = active_context$selection[[1]]$range,
                         text = insert_text,
                         id = active_context$id)
}


