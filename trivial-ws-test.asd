(defsystem trivial-ws-test
  :author "Fernando Borretti <eudoxiahp@gmail.com>"
  :license "MIT"
  :depends-on (:trivial-ws
               :trivial-ws-client
               :prove
               :find-port)
  :defsystem-depends-on (:prove-asdf)
  :components ((:module "t"
                :serial t
                :components
                ((:test-file "trivial-ws"))))
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run) :prove) c)))
