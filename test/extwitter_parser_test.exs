defmodule ExTwitter.ParserTest do
  @moduledoc false

  use ExUnit.Case, async: false

  alias ExTwitter.Parser

  test "correctly parses request params" do
    param = Parser.parse_request_params([track: "apple"])
    assert param == [{"track", "apple"}]

    param = Parser.parse_request_params([track: ["apple", "samsung"]])
    assert param == [{"track", "apple,samsung"}]

    param = Parser.parse_request_params([follow: [12389212, 995_719_891_624_673_280]])
    assert param == [{"follow", "12389212,995719891624673280"}]

    param = Parser.parse_request_params([follow: "995719891624673280"])
    assert param == [{"follow", "995719891624673280"}]

    # When passing a single element list
    param = Parser.parse_request_params([follow: [995719891624673280]])
    assert param == [{"follow", "995719891624673280"}]
  end
end
