require "./manual-generator/*"
require "option_parser"

module ManualGenerator
  include_base_url = false
  output = "doc.pdf"
  content = "#content"  # ex. "#main-content"
  custom_css = ""
  remote_css = false
  toc = "#summary a"  # ex. "#types-list"
  toc_links_attribute = "href"
  verbose_mode = false
  url = ""

  begin
    OptionParser.parse! do |parser|
      parser.banner = "Usage: manual-generator [arguments] URL"
      parser.on( "-a STRING", "--attribute=STRING", "CSS attribute to use for TOC links (default: \"#{toc_links_attribute}\")" ) { |a| toc_links_attribute = a }
      parser.on( "-b", "--include-base-url", "Include base URL document in PDF (default: false)" ) { include_base_url = true }
      parser.on( "-c STRING", "--content=STRING", "CSS element selector to look for the contents of the page (ex. \"#{content}\")" ) { |c| content = c }
      parser.on( "-o FILENAME", "--output=FILENAME", "Output filename (default: #{output})" ) do |o|
        output = o.strip
        if output.empty?
          puts "! Invalid output filename"
          exit
        end
      end
      parser.on( "-r", "--remote-css", "Fetch remote CSS styles (default: false)" ) { remote_css = true }
      parser.on( "-s FILENAME", "--custom-css=FILENAME", "Filename with custom CSS" ) { |f| custom_css = f }
      parser.on( "-t STRING", "--toc=STRING", "CSS element selector to look for the table of contents of the page (ex. \"#{toc}\")" ) { |t| toc = t }
      parser.on( "-h", "--help", "Show this help") do
        puts parser
        exit
      end
      parser.on( "-v", "--version", "Show version" ) do
        puts ManualGenerator::VERSION
        exit
      end
      parser.on( "-V", "--verbose", "Verbose mode" ) { verbose_mode = true }
      parser.unknown_args do |before, after|
        if before.any?
          url = before.first.strip
        elsif after.any?
          url = after.first.strip
        else
          puts parser
          exit
        end
        if url.empty?
          puts "! Invalid URL"
          exit
        end
        uri = URI.parse url
        if !uri.scheme
          puts "! Invalid URL - Please specify a full address (including \"http://\" or \"https://\")"
          exit
        end
        url = ( ( s = uri.scheme ) ? s : "http" ) + "://" + ( ( h = uri.host ) ? h : "" ) + ( ( p = uri.path ) ? p : "" )
      end
    end

    wrk = Worker.new( content_selector: content, custom_css: custom_css, include_base_url: include_base_url, output: output, remote_css: remote_css, toc_links_attribute: toc_links_attribute, toc_selector: toc, verbose_mode: verbose_mode, url: url )
    puts "--- Fetch..." if verbose_mode
    if wrk.fetch url
      puts "--- Convert..." if verbose_mode
      wrk.convert
      puts "<<< #{output}" if verbose_mode
      puts "--- Done." if verbose_mode
    end
  rescue e : Exception
    puts "Error: " + ( ( message = e.message ) ? message : "generic" )
  end
end
