Introduction to Programming
================
Johnathan Evanilla
10/28/2024

## Welcome

## Rstudio Tour

- Console Pane

- Environment Pane

- Text Editor Pane

- File Browser Pane

## What is a package?

Content adapted from
<https://datacarpentry.org/R-genomics/01-intro-to-R.html>

[Base R cheat
sheet](https://iqss.github.io/dss-workshops/R/Rintro/base-r-cheat-sheet.pdf)

### Hello World!

``` r
print("Hello world!")
```

    ## [1] "Hello world!"

``` r
getwd()
```

    ## [1] "/Users/jevanilla/Documents/Bigelow/CODE/hab-ews-namibia/R/01_programming_introdiction"

## Creating Objects

``` r
3+3
```

    ## [1] 6

``` r
# I'm adding 3 and 5
3+5
```

    ## [1] 8

``` r
#I'm adding 3 and 5
3+5
```

    ## [1] 8

``` r
# assign 3 to a
a <- 3
# assign 5 to b
b <- 5

# what now is a
a
```

    ## [1] 3

``` r
# what now is b
b
```

    ## [1] 5

``` r
#Add a and b
a + b
```

    ## [1] 8

## Functions

# Create a function that adds two numbers

``` r
adder <- function(a,b) {
  c = a+b
  return(c)
}
```

# test if it works

``` r
adder(5,5)
```

    ## [1] 10

# R has lots of functions built in, like `round()`

``` r
round(3.14159)
```

    ## [1] 3

# typing a `?` in front of the function will access the help page for that function

``` r
?round
```

# try using the `digits`

``` r
round(3.14159, digits=2)
```

    ## [1] 3.14

# you don’t need to declare the argument name, R can figure that out for you

``` r
round(3.14159, 2)
```

    ## [1] 3.14

## Vectors and data types

A vector of doubles

``` r
counts <- c(1, 2, 3, 100)
counts
```

    ## [1]   1   2   3 100

A vector of character

``` r
species <- c("alexandrium", "dinophysis", "pseudo_nitzchia")
species
```

    ## [1] "alexandrium"     "dinophysis"      "pseudo_nitzchia"

``` r
class(counts)
```

    ## [1] "numeric"

``` r
class(species)
```

    ## [1] "character"

``` r
numbers <- c("1", "2", "3")
class(numbers)
```

    ## [1] "character"

R also has a “date” class

``` r
today <- "2022-12-07"
```

``` r
class(today)
```

    ## [1] "character"

We can use the function `as.Date()` to change to date class

``` r
today <- as.Date(today)
class(today)
```

    ## [1] "Date"

[Date Formats in
R](https://www.r-bloggers.com/2013/08/date-formats-in-r/)

``` r
format(today, format="%A") #day of week
```

    ## [1] "Wednesday"

``` r
format(today, format="%B") #month
```

    ## [1] "December"

``` r
format(today, format="%U") #week of year
```

    ## [1] "49"

``` r
Sys.Date()
```

    ## [1] "2024-10-23"

``` r
class(Sys.Date())
```

    ## [1] "Date"

The logical class is used to store binary variables i.e. true or false,

``` r
present <- TRUE
class(present)
```

    ## [1] "logical"

``` r
length(counts)
```

    ## [1] 4

``` r
length(species)
```

    ## [1] 3

``` r
2 * counts
```

    ## [1]   2   4   6 200

Notice that you can’t add character and numeric vectors together

``` r
# counts + species
```

``` r
class(counts)
```

    ## [1] "numeric"

``` r
class(species)
```

    ## [1] "character"

``` r
str(counts)
```

    ##  num [1:4] 1 2 3 100

``` r
str(species)
```

    ##  chr [1:3] "alexandrium" "dinophysis" "pseudo_nitzchia"

``` r
counts <- c(counts, 4) # adding at the end
counts <- c(0, counts) # adding at the beginning
counts
```

    ## [1]   0   1   2   3 100   4

``` r
counts[3]
```

    ## [1] 2

``` r
counts[-1]
```

    ## [1]   1   2   3 100   4

``` r
mean(counts)
```

    ## [1] 18.33333

``` r
sd(counts)
```

    ## [1] 40.03332

``` r
sessionInfo()
```

    ## R version 4.4.1 (2024-06-14)
    ## Platform: x86_64-apple-darwin20
    ## Running under: macOS 15.0.1
    ## 
    ## Matrix products: default
    ## BLAS:   /Library/Frameworks/R.framework/Versions/4.4-x86_64/Resources/lib/libRblas.0.dylib 
    ## LAPACK: /Library/Frameworks/R.framework/Versions/4.4-x86_64/Resources/lib/libRlapack.dylib;  LAPACK version 3.12.0
    ## 
    ## locale:
    ## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
    ## 
    ## time zone: America/Los_Angeles
    ## tzcode source: internal
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] compiler_4.4.1    fastmap_1.2.0     cli_3.6.3         tools_4.4.1      
    ##  [5] htmltools_0.5.8.1 rstudioapi_0.16.0 yaml_2.3.10       rmarkdown_2.27   
    ##  [9] knitr_1.47        xfun_0.45         digest_0.6.37     rlang_1.1.4      
    ## [13] evaluate_0.24.0
