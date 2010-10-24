(use 'ring.adapter.jetty)

(defn app [req]
  {:status  200
   :headers {"Content-Type" "text/html"}
   :body    "Hello World from Ring"})

(run-jetty app {:port 8080})

