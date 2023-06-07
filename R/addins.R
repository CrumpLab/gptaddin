
#' line_editor
#'
#' This is an RStudio addin function that should become available after the package is installed.
#'
#' Highlight text in an editor window while using Rstudio, then select the addin from the drop-down menu.
#'
#' This function sends the selected text to a gpt-3.5-turbo chat model. The system prompt is:
#'
#' You are an editorial writing assistant. Your task is to edit the content you receive for improved clarity, flow, and reduced word count.
#'
#' The model receives the highlighted text, generates a response following the prompt, and returns to the new suggested text to the console.
#'
#' @return
#' @export
#'
#' @examples
line_editor <- function(){

  # get selected text
  selected_text <- rstudioapi::selectionGet()

  # run the api call to openai
  gpt <- openai::create_chat_completion(
    model = "gpt-3.5-turbo",
    messages = list(
      list(
        "role" = "system",
        "content" = "You are an editorial writing assistant. Your task is to edit the content you receive for improved clarity, flow, and reduced word count."
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

