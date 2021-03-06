\name{start_review_window}
\alias{start_review_window}
\title{Interactive visualisation of bibliographic data}
\description{Draw an interactive plot of a bibliography. Ordinations are calculated using LDA (library "topicmodels") and are displayed using Shiny and Plotly.}
\usage{
start_review_window(x)
}
\arguments{
  \item{x}{Bibliographic data, in one of three formats: a list returned by read_bibliography(); a data.frame such as returned from make_reference_dataframe(); or a previously saved output from start_review_window (class("review_info")).}
}
\value{
This function launches a Shiny app in the users' default browser. 

The display space is divided into three parts. From left to right, these are the sidebar; the plot window; and the selection panel. 

The sidebar shows a series of drop-down menus that can be used to customize or recalculate the central plot. It can be minimized when not in use. Note that the default settings for LDA (5 topics, 1000 iterations) prioritize speed over reliability - higher numbers of iterations will give more reliable results. 

The plot window shows an ordination of article weights calculated using LDA, with articles colored by their highest-weighted topic. Hovering over a point shows the title and abstract below the plot; clicking allows selection or deselection of that article (and optionally displays co-authorship data). Selecting a region of the plot and clicking zooms on the selected region; double-clicking without selecting a region returns the plot to its full extent.

The selection panel gives information on progress in selecting/deselecting articles. It also contains windwos for displaying topic-level infromation and article abstracts. All boxes in this panel can be minimized when not required.

Upon completion, the user can export information to a .csv or .rda file (saved to the working directory) using the 'export options' tab.
}