
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![R-CMD-check](https://github.com/CUREd-Plus/cuRed/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/CUREd-Plus/cuRed/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

# cuRed

An R package for working with CUREd data. This package handles the
ingress of data and linking between the different data sources.

## Installation

Install development versions of this package from
[GitHub](https://github.com/) using the following code.

``` r
# install.packages("devtools")
devtools::install_github("CUREd-Plus/cuRed")
```

## Usage

**TODO** Add usage once we have code to work with!

## Development and Contributing

This section describes how to contribute to the development of `cuRed`.

### Create an Issue

If you find there are problems or errors with running the code please
search and review the existing
[issues](https://github.com/CUREd-Plus/cuRed/issues) (both `open` and
`closed`) and [pull requests](https://github.com/CUREd-Plus/cuRed/pulls)
to see if anyone has reported the bug or requested the feature already
and work is already in progress. If nothing exists then you should
create a [new issue](https://github.com/CUREd-Plus/cuRed/issues/new).

### Development/Contributing

If you wish to contribute to the development of the `cuRed` package by
fixing bugs, adding to or extending documentation or extending
functionality or the datasets/variables it works with please setup your
development environment to work with
[pre-commit](https://pre-commit.com/) as we use [pre-commit
hooks](https://pre-commit.com/hooks.html) to lint the code and ensure
the package meets the common standards prescribed for package
development and passes linting with [styler](https://styler.r-lib.org/)
and [lintr](https://lintr.r-lib.org/).

If you are unfamiliar working with Git and GitHub with R then you may
find [Happy Git and GitHub for the useR](https://happygitwithr.com/) a
useful resource.

#### Cloning the Repository

If you are a member of the the [CUREd-Plus
Organisation](https://github.com/CUREd-Plus/) you can [clone the
repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)
and make contributions directly from a `branch`. If you are not a member
then you will have to
[fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo)
the repository to your own account and then [clone
that](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)

``` bash
# Member of CUREd-Plus Organisation
git clone git@github.com:AFM-SPM/TopoStats.git
# Non-member of CUREd-Plus cloning fork
git clone git@github.com:<YOUR_GITHUB_USERNAME>/TopoStats.git
```

### Creating a branch

If you have cloned the repository directly you will now create a
[branch](https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging)
to work on the issue you wish to address. It is not compulsory but we
try to use a consistent nomenclature for branches that shows who has
worked on the branch, the issue it pertains to and a short description
of the work. To which end you will see branches with the form
`<GITHUB_USERNAME>/<GITHUB_ISSUE>-<SHORT-DESCRIPTION>`. Some examples
are shown below…

| `BRANCH`                 | `GITHUB_USERNAME`                     | `ISSUE`                                           | `SHORT-DESCRIPTION`                                                                |
|:-------------------------|:--------------------------------------|:--------------------------------------------------|:-----------------------------------------------------------------------------------|
| `ns-rse/1-package-setup` | [`ns-rse`](https://github.com/ns-rse) | [1](https://github.com/CUREd-Plus/cuRed/issues/1) | `package-setup` short for the issue subject *Package setup, checking and linting*. |

## Coding Standards

To make the codebase easier to maintain we ask that you follow the
guidelines below on coding style, linting, typing, documentation and
testing.

### Coding Style/Linting

Using a consistent coding style has many benefits (see [Linting : What
is all the fluff
about?](https://rse.shef.ac.uk/blog/2022-04-19-linting/)). For this
project we aim to adhere to [`lintr`](https://github.com/r-lib/lintr/)
styles and for the package structure we are following the [R Packages
(2e)](https://r-pkgs.org/) guidelines.

`pre-commit` hooks are used to ensure these are consistent before Git
commits are made.

#### `pre-commit`

[pre-commit](https://pre-commit.com/) runs Git
[hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) that
it is configured to run on the code base prior to Git commits being
made. It is highly configurable but as it is written in Python requires
installing in order to analyse the R code and package structure of
`cuRed`. If you are not already familiar with Python and the various
options for Virtual Environments the simplest solution will likely be to
install [miniconda](https://docs.conda.io/en/latest/miniconda.html) and
then install the `pre-commit` package and install within the repository

``` bash
conda install conda-forge pre-commit
cd path/to/cloned/cuRed
pre-commit install --install-hooks
```

For more an overview of `pre-commit` see the post [pre-commit:
Protecting your future self](https://rse.shef.ac.uk/blog/pre-commit/).
