# gptaddin <a href="https://crumplab.com/gptaddin"><img src="man/figures/logo.png" align="right" height="120" /></a>

<!-- badges: start -->
  [![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
  <!-- badges: end -->

The purpose of this package is to create RStudio addins for interfacing with the [OpenAI API](https://openai.com/) through the [openai R library](https://github.com/irudnyts/openai). 

The add-ins are intended to provide writing assistant functions, such as taking selected text in the RStudio editor and having a GPT model return edits.

This is an experimental project undergoing a short spurt of development for my personal use.

I'm not encouraging anyone to install this package, but it could serve as a useful example for other people looking to customize their own writing assistant in RStudio.

I blogged about the process of making and using this package over a few posts:

<https://crumplab.com/blog/770_rstudio_gpt/>

<https://crumplab.com/blog/668_gpt_adventure/>

<https://crumplab.com/blog/666_gpt_grammar/>

See the example page for some more explanation and ongoing dev notes.

<https://crumplab.com/gptaddin/articles/examples.html>

### Usage notes

I don't currently have plans to make this package ready for a larger audience to install and use without any hassle. There are several privacy concerns to consider when sending data to OpenAI, and the behavior of LLMs can be unstable. In my opinion, interacting with these tools requires a great deal of human supervision. For example, while using the functions in this package myself, I rarely get results that are useful straight away. The reason I'm creating these functions is to personally understand what I am sending and receiving, as well as to have programmatic control over my actions. For these reasons, as I mentioned earlier, I'm not suggesting that anyone should install and use this package.

In case this rough scratchpad of a package is useful for others, here's a quick rundown.

It is possible to install this package from github, **although, I'm not recommending this option**:

```
#install.packages("devtools")
devtools::install_github("CrumpLab/gptaddin")
```

I imagine it would be more useful to fork, clone, or otherwise download the repo, install it locally, and then modify it as needed for your use case. 

1. Download the repo to your computer
2. Open the .Rproj file in Rstudio
3. Install the package from the build tab.

I'm following the basic skeleton for making R packages using pkgdown. See the [R packages book](https://r-pkgs.org) for more info.

#### Addins

Once this package is installed, several addins should become available in Rstudio. See the [examples page](https://crumplab.com/gptaddin/articles/examples.html) for some tips on usage. 

I wrote these addins to explore convenient ways to use the OpenAI API while using RStudio. They do things like send highlighted text in the RStudio editor to an LLM, and then print results to the console, or to the editor window. 

**This process only works if you have an account with OpenAI, and you have created an API key**.

1.  Create a secret key in openai, copy it and put it somewhere safe. Don't share it.

2.  The `openai` R library looks for an environment variable called `OPENAI_API_KEY`, which can be set a [number of ways](https://irudnyts.github.io/openai/).

My strategy was to add a key-value pair directly to the `.Renviron` file at the user level.

```{r}
#| eval: false

# open the .Renviron file
usethis::edit_r_environ()
```

Then edit the file to add the new key-value pair, and restart R.

```{r}
#| eval: false

# add new environment variable to above and save
OPENAI_API_KEY=XXXXXXXXXXXXX
```

After you restart R, you can check if R recognizes the new environment variable:

```{r}
#| eval: false
Sys.getenv("OPENAI_API_KEY")
```

**The functions in this package assume the above, and would need to be modified to handle alternate ways of sending the API key.**

#### Writing addins

Some of the addins in this package may do things you want them to. If not, I suggest writing your own to achieve your desired workflow.

Documentation for writing custom addins is [here](https://RStudio.github.io/RStudioaddins/). RStudio addins are available from a dropdown menu and/or triggered by hot-key macros.

The steps for writing addins are:

1.  Write functions as you normally would do in the R folder. You can see the functions I wrote in `R/addins.R`
3.  [Register the functions as addins](https://rstudio.github.io/rstudioaddins/#registering-addins) using a .dcf file placed in `inst/rstudio/addins.dcf`
4.  Install the R package from the build tab anytime you make changes
5.  The addins should now be available for use in RStudio

#### Shiny app for grammar checking

The newest piece to this package is a Shiny App for grammar checking. I'm starting to get decent results with this approach. The functions for the shiny app are in `R/grammar_shiny.R`.

```
gptaddin::run_grammar_checker("yourfile.qmd")
```

### Other examples of using GPT in RStudio

- [gptstudio](https://github.com/MichelNivard/gptstudio)







