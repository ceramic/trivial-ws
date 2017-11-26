(defsystem trivial-ws-client
  :author "Fernando Borretti <eudoxiahp@gmail.com>"
  :maintainer "Fernando Borretti <eudoxiahp@gmail.com>"
  :license "MIT"
  :depends-on (:websocket-driver
               :cl-async)
  :components ((:module "src"
                :serial t
                :components
                ((:file "client"))))
  :description "Trivial WebSockets."
  :long-description
  #.(uiop:read-file-string
     (uiop:subpathname *load-pathname* "README.md"))
  :in-order-to ((test-op (test-op trivial-ws-test))))
