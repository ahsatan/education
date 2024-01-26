# Erlang foundation code from https://www.erlang.org/doc/man/gen_tcp
# - lsock = listening socket (make initial connection for a request)
# - sock = client socket (receive request data and return response data)
# - bin = binary request string
# server() ->
#     {ok, LSock} = gen_tcp:listen(5678, [binary, {packet, 0},
#                                         {active, false}]),
#     {ok, Sock} = gen_tcp:accept(LSock),
#     # return all available bytes of request into bin
#     {ok, Bin} = gen_tcp:recv(Sock, []),
#     ok = gen_tcp:close(Sock),
#     ok = gen_tcp:close(LSock),
#     Bin.

defmodule Servy.HttpServer do
  import Servy.Handler, only: [handle: 1]

  @doc """
  Starts the server on the given `port` of localhost.
  Ports <= 1023 are reserved for OS.
  """
  def start(port) when is_integer(port) and port > 1023 do
    IO.puts "Starting the http server..."
    # Creates a socket to listen for client connections.
    # `:binary` - open the socket in "binary" mode and deliver data as binaries
    # `backlog: 10` - increases number of potential queued requests from default of 5
    # `packet: :raw` - deliver the entire binary without doing any packet handling
    # `active: false` - receive data when we're ready by calling `:gen_tcp.recv/2`
    # `reuseaddr: true` - allows reusing the address if the listener crashes
    options = [:binary, backlog: 10, packet: :raw, active: false, reuseaddr: true]
    {:ok, lsock} = :gen_tcp.listen(port, options)

    IO.puts "\n🎧  Listening for connection requests on port #{port}...\n"

    accept_loop lsock
  end

  # Accepts client connections on the `lsock`.
  defp accept_loop(lsock) do
    IO.puts "⌛️  Waiting to accept a client connection...\n"

    # Suspends (blocks) and waits for a client connection. When a connection
    # is accepted, `csock` is bound to a new client socket.
    {:ok, csock} = :gen_tcp.accept lsock

    IO.puts "⚡️  Connection accepted!\n"

    # Receives the request and sends a response over the client socket.
    pid = spawn(fn -> serve(csock) end)

    # ensure socket is closed if spawned process dies early
    :ok = :gen_tcp.controlling_process csock, pid

    # Loop back to wait and accept the next connection.
    accept_loop lsock
  end

  # Receives the request on the `csock` and sends a response back over the same socket.
  defp serve(csock) do
    IO.puts "#{inspect self()}: working on it!"

    csock
    |> read_request
    |> handle()
    |> write_response(csock)
  end

  # Receives a request on the `csock`.
  defp read_request(csock) do
    # return all available bytes of the client request into request
    {:ok, request} = :gen_tcp.recv csock, 0

    IO.puts "➡️  Received request:\n"
    IO.puts request

    request
  end

  # Sends the `response` over the `csock`.
  defp write_response(response, csock) do
    :ok = :gen_tcp.send csock, response

    IO.puts "⬅️  Sent response:\n"
    IO.puts response

    # Closes the client socket, ending the connection.
    :gen_tcp.close csock
  end
end
