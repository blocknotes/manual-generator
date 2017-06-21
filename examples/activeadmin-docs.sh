#!/bin/sh

URL="https://activeadmin.info/documentation.html"

crystal src/manual-generator.cr -- -V $URL -c ".docs-content" -t ".toc > ol > li > a" -o "examples/activeadmin-docs.pdf"
