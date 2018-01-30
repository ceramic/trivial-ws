(defsystem trivial-ws
  :author "Fernando Borretti <eudoxiahp@gmail.com>"
  :maintainer "Fernando Borretti <eudoxiahp@gmail.com>"
  :license "MIT"
  :version "0.1"
  :homepage "https://github.com/ceramic/trivial-ws"
  :bug-tracker "https://github.com/ceramic/trivial-ws/issues"
  :source-control (:git "git@github.com:ceramic/trivial-ws.git")
  :depends-on (:hunchensocket)
  :components ((:module "src"
                :serial t
                :components
                ((:file "server"))))
  :description "Trivial WebSockets."
  :long-description
  #.(uiop:read-file-string
     (uiop:subpathname *load-pathname* "README.md"))
  :in-order-to ((test-op (test-op trivial-ws-test))))
