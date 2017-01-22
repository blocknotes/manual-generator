#!/bin/sh

URL="https://crystal-docs.org/blocknotes/wkhtmltopdf-crystal/"

crystal src/manual-generator.cr -- -V $URL -c "#main-content" -t "#types-list a" -s "examples/custom.css" -o "examples/crystal-docs-wkhtmltopdf.pdf"
