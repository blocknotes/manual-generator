# manual-generator

A Crystal program to generate PDF manuals from an HTML documentation site.

## Usage / Command line options

```
Usage: manual-generator [arguments] URL
    -a STRING, --attribute=STRING    CSS attribute to use for TOC links (default: "href")
    -b, --include-base-url           Include base URL document in PDF (default: false)
    -c STRING, --content=STRING      CSS element selector to look for the contents of the page (ex. "#content")
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
