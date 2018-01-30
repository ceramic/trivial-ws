(in-package :cl-user)
(defpackage trivial-ws
  (:use :cl)
  (:export :server
           :make-server
           :clients
           :send
           :start
           :stop
           :+default-address+
           :+default-timeout+)
  (:documentation "Trivial WebSockets."))
(in-package :trivial-ws)

(defclass client (hunchensocket:websocket-client)
  ((name :initarg :user-agent :reader name)))

(defclass server (hunchensocket:websocket-resource)
  ((on-connect :reader on-connect
               :initarg :on-connect
               :initform #'(lambda (server)
                             (declare (ignore server))
                             nil)
               :type function
               :documentation "The function that is called when a client connects.")
   (on-disconnect :reader on-disconnect
                  :initarg :on-disconnect
                  :initform #'(lambda (server)
                                (declare (ignore server))
                                nil)
                  :type function
                  :documentation "The function that is called when a client
                  disconnects.")
   (on-message :reader on-message
               :initarg :on-message
               :initform #'(lambda (server message)
                             (declare (ignore server message))
                             nil)
               :type function
               :documentation "The function that's called when a client sends a message."))
  (:default-initargs :client-class 'client))

(defun make-server (&key on-connect on-disconnect on-message)
  "Create a server given the three callback functions."
  (make-instance 'server
                 :on-connect on-connect
                 :on-disconnect on-disconnect
                 :on-message on-message))

(defun clients (server)
  "Return a list of server clients."
  (hunchensocket:clients server))

(defun send (client string)
  "Send a string of text to the client."
  (hunchensocket:send-text-message client string))

(defmethod hunchensocket:client-connected ((server server) client)
  (declare (ignore client))
  (funcall (on-connect server) server))

(defmethod hunchensocket:client-disconnected ((server server) client)
  (declare (ignore client))
  (funcall (on-disconnect server) server))

(defmethod hunchensocket:text-message-received ((server server) client message)
  (declare (ignore client))
  (funcall (on-message server) server message))

(defparameter +default-address+ "0.0.0.0")
(defparameter +default-timeout+ 300)

(defun start (server port &key (address +default-address+) (timeout +default-timeout+))
  "Start the server. Returns a handler object."
  (let ((handler (make-instance 'hunchensocket:websocket-acceptor
                                :port port
                                :websocket-timeout timeout)))
    (push (lambda (request)
            (declare (ignore request))
            server)
          hunchensocket:*websocket-dispatch-table*)
    (hunchentoot:start handler)))

(defun stop (handler)
  "Stops a server handler."
  (hunchentoot:stop handler)
  (pop hunchensocket:*websocket-dispatch-table*)
  t)
