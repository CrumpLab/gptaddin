
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
  print(gpt$choices$message.content)
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
  print(gpt$choices$message.content)
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


#' Send highlighted text as completion prompt to gpt-3.5-turbo
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




