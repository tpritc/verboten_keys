# frozen_string_literal: true

class HtmlTestApp
  attr_accessor :html

  def initialize(html)
    @html = html
  end

  def call(_env)
    [
      200,
      {
        "Content-Type" => "text/html",
        "Content-Length" => html.bytesize.to_s
      },
      [html]
    ]
  end
end
