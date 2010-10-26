(ns recomendation-engine.server
  (:use ring.adapter.jetty)
  (:use ring.middleware.params)
  (:use ring.middleware.stacktrace)
  (:use ring.middleware.reload)
  (:use recomendation-engine.app))

(defn parse-integer [str]
  (try (Integer/parseInt str) 
       (catch NumberFormatException nfe 0)))

(defn parse-float [str]
  (try (Float/parseFloat str) 
       (catch NumberFormatException nfe 0.0)))

(defn new-rating? [{params :params}]
  (and (params "user_id")
       (params "exercise_id")
       (params "rating")))

(defn build-rating [{params :params}]
   {:user_id     (parse-integer (params "user_id"))
   :exercise_id  (parse-integer (params "exercise_id"))
   :rating       (parse-float   (params "rating"))})

(defn handler [request]
  {:status  200
   :headers {"Content-Type" "text/html"}
   :body    (if (new-rating? request)
              (do 
                (handle-rating
                  (build-rating request))
                (str @*user-prefs*))
              "No rating")})
         
;TODO wrap-reload, wrap-stacktrace are only for dev
(def app
  (-> #'handler
    (wrap-reload '(recomendation-engine.server))
    (wrap-params)
    (wrap-stacktrace)))
    
(defn boot-server []
  (run-jetty app {:port 8080}))

