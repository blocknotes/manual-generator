#!/bin/sh

URL="https://veelenga.gitbooks.io/crystal-patterns/content/"

crystal src/manual-generator.cr -- -V $URL -c ".book-body .page-inner" -t ".book-summary .chapter a" -s "examples/custom.css" -o "examples/gitbooks-crystal-patterns.pdf"
