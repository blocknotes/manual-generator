#!/bin/sh

URL="http://wkhtmltopdf.org/libwkhtmltox/annotated.html"

crystal src/manual-generator.cr -- -V $URL -c ".headertitle,.contents" -t ".directory .entry a" -s "examples/custom.css" -e ".headertitle { font-weight: bold; font-size: 20px; }" -o "examples/doxygen-wkhtmltopdf.pdf"
