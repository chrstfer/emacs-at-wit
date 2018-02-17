#!/bin/bash
## TODO: we need to make the output file look better, and to clean up
##

[ $# -eq 0 ] && { echo "Usage: $0 ~/path/to/rmdFile"; exit 1; }

infile="$1"
fname="${infile%.*}"
md="${fname}.md"   #change ext. to md
org="${fname}.org" # change ext. to org

echo $md
echo $org

# want to run this R script to make md file
R -q -e "require(knitr);require(markdown);knit('${infile}','${md}')"
# convert md to org
pandoc -o $org $md
# clean up
rm $md
