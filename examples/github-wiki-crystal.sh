#!/bin/sh

URL="https://github.com/crystal-lang/crystal/wiki"

crystal src/manual-generator.cr -- -V $URL -c "#wiki-wrapper" -t ".wiki-pages-box a.wiki-page-link" -o "examples/github-wiki-crystal.pdf"
