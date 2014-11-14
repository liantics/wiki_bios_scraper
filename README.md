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

##Generating Biography Entries
Generating new biography entries is intentionally a painful, manual process, to prevent accidental overload of wikipedia.

For each page you want to scrape, add it to the WikiBiographyClass table via
the console. You'll need to specify the following: 

###class_type:
This is a string of the portion of the URL between the ":" and the "-Class" in the url.

For example:

 "FA"

 from the

 "... /wiki/Category:FA-Class_biography_articles"

###class_url:
This is the url, in quotes.

###traversal_status:
Indicates whether or not the class has been scraped already. Set this to false, or the scraper will skip it.

It's best to add one page at a time, run the scrape, then wait a few minutes after the scrape is complete before adding and running another one.

You probably don't want wikipedia to block your IP address.

###Pages That Have Been Scraped
+  "http://en.wikipedia.org/wiki/Category:FA-Class_biography_articles",
+  "http://en.wikipedia.org/wiki/Category:A-Class_biography_articles",
+  "http://en.wikipedia.org/wiki/Category:GA-Class_biography_articles",
+  "http://en.wikipedia.org/wiki/Category:B-Class_biography_articles",
+  "http://en.wikipedia.org/wiki/Category:C-Class_biography_articles",
+  "http://en.wikipedia.org/wiki/Category:Disambig-Class_biography_articles",
+  "http://en.wikipedia.org/wiki/Category:Book-Class_biography_articles"

###Pages That Have Not Been Scraped
+  "http://en.wikipedia.org/wiki/Category:stub-Class_biography_articles",
+  "http://en.wikipedia.org/wiki/Category:start-Class_biography_articles",
+  "http://en.wikipedia.org/wiki/Category:Template-Class_biography_articles",
+  "http://en.wikipedia.org/wiki/Category:NA-Class_biography_articles",
+  "http://en.wikipedia.org/wiki/Category:Unassessed_biography_articles",
+  "http://en.wikipedia.org/wiki/Category:List-Class_biography_articles"
