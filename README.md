# trivial-ws

Trivial WebSockets, built on top of [Hunchensocket][hs] for the server and
[websocket-driver][driver] for the client.

# Usage

Here's a simple echo server:

~~~lisp
(defvar *server*
  (trivial-ws:make-server
    :on-connect #'(lambda (server)
                    (format t "Connected~%"))
    :on-disconnect #'(lambda (server)
                       (format t "Disconnected~%"))
    :on-message #'(lambda (server message)
                    (format t "Received: ~A~%" message)
                    (trivial-ws:send (first (trivial-ws:clients server))
                                     message))))
~~~

Then start it:

~~~lisp
(defvar *handler* (trivial-ws:start *server* 4040))
~~~

Then go to http://www.websocket.org/echo.html and change the server to
`ws://localhost:4040/` and try it out.

You can stop it with `(trivial-ws:stop *handler*)`.

Inside the callbacks you can use two functions: `(trivial-ws:clients server)`
will return the list of connected clients, and `(trivial-ws:send client
"string")` will send a message to a selected client.

# License

Copyright (c) 2016 Fernando Borretti

Licensed under the MIT License.

[hs]: https://github.com/capitaomorte/hunchensocket
[driver]: https://github.com/fukamachi/websocket-driver
