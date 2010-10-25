(ns recomendation-engine.server
  (:use ring.adapter.jetty)
  (:use ring.middleware.params)
  (:use ring.middleware.stacktrace)
  (:use ring.middleware.reload))

(defn new-rating [request]
  {:status  200
   :headers {"Content-Type" "text/html"}
   :body    "Cozy Recomendation Server Is Running: w00t!"})

(def app
  (-> #'new-rating
    (wrap-reload '(recomendation-engine.server))
    (wrap-params)
    (wrap-stacktrace)))
    
(defn boot-server []
  (run-jetty app {:port 8080}))

