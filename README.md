# manual-generator

A Crystal program to generate PDF manuals from an HTML documentation site.

It gets all the links found in a table of contents element, downloads them and converts to a unique PDF using [wkhtmltopdf-crystal](https://github.com/blocknotes/wkhtmltopdf-crystal).

## Install

Build the binary tool:

`crystal build --release src/manual-generator.cr`

## Usage / Command line options

```
Usage: manual-generator [arguments] URL
    -a STRING, --attribute=STRING    CSS attribute to use for TOC links (default: "href")
    -b, --include-base-url           Include base URL document in PDF (default: false)
    -c STRING, --content=STRING      CSS element selector to look for the contents of the page (ex. "#content")
    -e STRING, --extra-css=STRING    Extra CSS styles (ex. "#nav_bar { display: none; }")
    -o FILE, --output=FILE           Output filename (default: doc.pdf)
    -r, --remote-css                 Fetch remote CSS styles (default: false)
    -s FILE, --custom-css=FILE       Filename with custom CSS
    -t STRING, --toc=STRING          CSS element selector to look for the table of contents of the page (ex. "#summary a")
    -h, --help                       Show this help
    -v, --version                    Show version
    -V, --verbose                    Verbose mode
```

## Examples

```sh
manual-generator -V "https://crystal-docs.org/blocknotes/wkhtmltopdf-crystal/" -c "#main-content" -t "#types-list a" -o test.pdf
```

See [examples](https://github.com/blocknotes/manual-generator/tree/master/examples) folder.

## Contributors

- [Mattia Roccoberton](http://blocknot.es) - creator, maintainer
