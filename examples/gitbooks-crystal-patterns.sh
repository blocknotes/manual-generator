#!/bin/sh

URL="https://veelenga.gitbooks.io/crystal-patterns/content/"
#CUSTOM="examples/custom.css"
CUSTOM="examples/highlightjs-github.css"

crystal src/manual-generator.cr -- -V $URL -c ".book-body .page-inner" -t ".book-summary .chapter a" -s $CUSTOM -o "examples/gitbooks-crystal-patterns.pdf"
