# Wiki Biography Processor

This project collects the list of biographies from wikipedia and determines the
gender of the subject.

## Purpose
Assess the percentage of biographies by gender, inspired by work presented at
the Boston Girl Geek Dinner(@BosGGD) in September, 2014.

## Tools and Techniques
The tool uses nokigiri to screen scrape the names from the entire wikipedia biography catalog,
then uses a gem that analyzes names for gender.

Some manual analysis and clean-up is required to handle instances where the name
string begins with something other than a name, such as "Prince" or
"Assassination of," among others, or where the name is androgynous. Such
instances are flagged.
