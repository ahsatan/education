defmodule HandlerTest do
  use ExUnit.Case, async: true

  import Servy.Handler, only: [handle: 1]

  test "GET /wildthings" do
    request = """
    GET /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
           HTTP/1.1 200 OK\r
           Content-Type: text/html\r
           Content-Length: 20\r
           \r
           Bears, Lions, Tigers
           """
  end

  test "GET /wildlife" do
    request = """
    GET /wildlife HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
           HTTP/1.1 200 OK\r
           Content-Type: text/html\r
           Content-Length: 20\r
           \r
           Bears, Lions, Tigers
           """
  end

  test "GET /bears" do
    request = """
    GET /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 418\r
    \r
    <h1>All The Bears!</h1>\r
    \r
    <ul>\r
      <li>Brutus - Grizzly</li>
      <li>Iceman - Polar</li>
      <li>Kenai - Grizzly</li>
      <li>Paddington - Brown</li>
      <li>Roscoe - Panda</li>
      <li>Rosie - Black</li>
      <li>Scarface - Grizzly</li>
      <li>Smokey - Black</li>
      <li>Snow - Polar</li>
      <li>Teddy - Brown</li>
    </ul>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /bears/1" do
    request = """
    GET /bears/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 72\r
    \r
    <h1>Show Bear</h1>
    <p>
    Is Teddy hibernating? <strong>true</strong>
    </p>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /bears?id=1" do
    request = """
    GET /bears?id=1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 72\r
    \r
    <h1>Show Bear</h1>
    <p>
    Is Teddy hibernating? <strong>true</strong>
    </p>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "DELETE /bears/1" do
    request = """
    DELETE /bears/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 403 Forbidden\r
    Content-Type: text/html\r
    Content-Length: 38\r
    \r
    You can't delete Bear 1 (or any bear)!
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "POST /bears" do
    request = """
    POST /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/x-www-form-urlencoded\r
    Content-Length: 21\r
    \r
    name=Baloo&type=Brown
    """

    response = handle(request)

    assert response == """
           HTTP/1.1 201 Created\r
           Content-Type: text/html\r
           Content-Length: 33\r
           \r
           Created a Brown bear named Baloo!
           """
  end

  test "GET /bears/new" do
    request = """
    GET /bears/new HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length:  240\r
    \r
    <form action="/bears" method="POST">
     <p>
       Name:<br />
       <input type="text" name="name" />
     </p>
     <p>
       Type:<br />
       <input type="text" name="type" />
     </p>
     <p>
       <input type="submit" value="Create Bear" />
     </p>
    </form>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /about" do
    request = """
    GET /about HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 328\r
    \r
    <h1>Clark's Wildthings Refuge</h1>

    <blockquote>
      When we contemplate the whole globe as one great dewdrop, striped and dotted
      with continents and islands, flying through space with other stars all singing
      and shining together as one, the whole universe appears as an infinite storm
      of beauty. -- John Muir
    </blockquote>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /pages/faq" do
    request = """
    GET /pages/faq HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 652\r
    \r
    <h1>Frequently Asked Questions</h1>
    <ul>
      <li>
        <p><strong>Have you really seen Bigfoot?</strong></p>
        <p>Yes! In this <a href=\"https://www.youtube.com/watch?v=ZMBeN4Kr4LE\">totally believable video</a>!</p>
      </li>
      <li>
        <p><strong>No, I mean seen Bigfoot <em>on the refuge</em>?</strong></p>
        <p>Oh! Not yet, but we’re <em>still looking</em>…</p>
      </li>
      <li>
        <p><strong>Can you just show me some code?</strong></p>
        <p>Sure! Here’s some Elixir:</p>
        <pre><code class=\"elixir\">[&quot;Bigfoot&quot;, &quot;Yeti&quot;, &quot;Sasquatch&quot;] |&gt; Enum.random()</code></pre>
      </li>
    </ul>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /bigfoot" do
    request = """
    GET /bigfoot HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
           HTTP/1.1 404 Not Found\r
           Content-Type: text/html\r
           Content-Length: 17\r
           \r
           No /bigfoot here.
           """
  end

  test "GET /api/bears" do
    request = """
    GET /api/bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: application/json\r
    Content-Length: 605\r
    \r
    [{"id":1,"name":"Teddy","type":"Brown","hibernating":true},
     {"id":2,"name":"Smokey","type":"Black","hibernating":false},
     {"id":3,"name":"Paddington","type":"Brown","hibernating":false},
     {"id":4,"name":"Scarface","type":"Grizzly","hibernating":true},
     {"id":5,"name":"Snow","type":"Polar","hibernating":false},
     {"id":6,"name":"Brutus","type":"Grizzly","hibernating":false},
     {"id":7,"name":"Rosie","type":"Black","hibernating":true},
     {"id":8,"name":"Roscoe","type":"Panda","hibernating":false},
     {"id":9,"name":"Iceman","type":"Polar","hibernating":true},
     {"id":10,"name":"Kenai","type":"Grizzly","hibernating":false}]
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "POST /api/bears" do
    request = """
    POST /api/bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/json\r
    Content-Length: 21\r
    \r
    {"name": "Breezly", "type": "Polar"}
    """

    response = handle(request)

    assert response == """
           HTTP/1.1 201 Created\r
           Content-Type: text/html\r
           Content-Length: 35\r
           \r
           Created a Polar bear named Breezly!
           """
  end

  defp remove_whitespace(text) do
    String.replace(text, ~r{\s}, "")
  end
end
