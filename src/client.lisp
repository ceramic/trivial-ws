(in-package :cl-user)
(defpackage trivial-ws.client
  (:use :cl)
  (:export :client
           :make-client
           :send
           :with-client-connection)
  (:documentation "Trivial WebSockets."))
(in-package :trivial-ws.client)

(defclass client ()
  ((ws :accessor client-ws
       :initarg :ws)
   (on-message :reader client-on-message
               :initarg :on-message
               :type function))
  (:documentation "A client."))

(defun make-client (url &key on-message)
  (let* ((ws (wsd:make-client url))
         (client (make-instance 'client
                                :ws ws
                                :on-message on-message)))
    (wsd:on :message ws
            #'(lambda (message)
                (funcall (client-on-message client) client message)))
    client))

(defun send (client text &key callback)
  "Send text to the server."
  (with-slots (ws) client
    (wsd:send ws text :callback callback)))

(defmacro with-client-connection ((client) &body body)
  (let ((c (gensym)))
    `(as:with-event-loop ()
       (let ((,c (client-ws ,client)))
         (wsd:start-connection ,c)
         (unwind-protect
              ,@body
           (wsd:close-connection ,c)
           (as:exit-event-loop))))))
