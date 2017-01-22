require "http/client"
require "myhtml"
require "modest"
require "wkhtmltopdf-crystal"

module ManualGenerator
  class Worker
    FETCH_DELAY = 1  # Just a small delay (in seconds) to make webservers happy
    SEPARATOR = "<div style='page-break-after:always;'></div>\n"

    def initialize( *, @content_selector : String, @custom_css : String, include_base_url : Bool, @output : String, @remote_css : Bool, @toc_links_attribute : String, @toc_selector : String, url : String, @verbose_mode : Bool )
      @title = "Document"
      @styles = ""
      @head = [] of String
      @index = [] of String
      @page = ""
      if url[-1] == '/'
        @url = url
      else
        @url = ( url.includes?( '.' ) ? File.dirname( url ) : url ) + '/'
      end
      @include_base_url = include_base_url
    end

    def convert
      @page += "\n</body>\n</html>\n"
      # puts @page  # DEBUG
      pdf = Wkhtmltopdf::WkPdf.new @output
      pdf.convert @page
    end

    def fetch( url : String ): Bool
      response = HTTP::Client.get url
      case response.status_code
      when 200  # OK
        parser = Myhtml::Parser.new response.body
        if parser.root
          if @index.empty?
            if @include_base_url
              content = parser.css( @content_selector ).map( &.to_html ).to_a
              add_content content.first if content.any?
            end
            # Get the head and table of contents only once
            unless doc_init parser
              puts "### ERROR while fetching: no links in TOC"
              return false
            end
          else
            content = parser.css( @content_selector ).map( &.to_html ).to_a
            add_content content.first if content.any?
          end
        end
        true
      when 302  # redirect
        puts "### ERROR while fetching: " + url + "\n    Redirect required => #{response.headers["Location"] ? response.headers["Location"] : ""}\n    HTTP status code #{response.status_code}"
        false
      else
        puts "### ERROR while fetching: " + url + "\n    HTTP status code #{response.status_code}"
        false
      end
    end

    protected def add_content( content )
      if content
        if @page.empty?
          @page = "<!DOCTYPE html>\n<html>\n<head>\n" + @head.join( "\n" ) + "\n<style>\n" + @styles + "</style>\n</head>\n<body>\n"
        else
          @page += SEPARATOR
        end
        @page += content
      end
    end

    protected def doc_init( parser )
      parser.css( "head *" ).each do |node|
        @head.push node.to_html
        if @remote_css && node.tag_name == "link" && ( href = node.attributes["href"]? )
          # Get remote CSS styles
          uri = URI.parse href
          if !uri.scheme  # relative URL
            puts ">>: " + @url + href if @verbose_mode
            response = HTTP::Client.get @url + href
            @styles += response.body if response.status_code
          end
        end
      end
      unless @custom_css.empty?
        if File.exists? @custom_css
          @styles += File.read @custom_css
        else
          puts "!!! warning: custom css file not found: #{@custom_css}"
        end
      end
      parser.css( @toc_selector ).map( &.attribute_by( @toc_links_attribute ) ).to_a.each do |link|
        @index.push( link ) if link && valid_link( link )
      end
      return false unless @index.any?
      @index.each do |link|
        sleep FETCH_DELAY
        uri = URI.parse link
        link = @url + link unless uri.scheme
        puts ">>> " + link if @verbose_mode
        fetch link
      end
      true
    end

    protected def valid_link( link : String )
      link[0] != '#' &&  # Skip anchors
      !@index.includes?( link )  # Unique links
    end
  end
end
