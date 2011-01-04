(ns recomendation-engine.server
  (:use ring.adapter.jetty)
  (:use ring.middleware.params)
  (:use recomendation-engine.app)
  (:require [recomendation-engine.rails :as rails])
  (:require [clj-yaml.core :as yaml]))

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
                "Rating accepted")
              "No rating")})
         
;TODO wrap-reload, wrap-stacktrace are only for dev
(def app
  (-> #'handler
    (wrap-params)))

(def server-uris 
  (:recomendation_server_uri
    (yaml/parse-string
      (slurp "../config/config.yml"))))

(defn get-port [uri]
  (or 
    ((first (re-seq #"^\w+://[^/:]+:?(\d+)?/?" uri)) 1)
    ; By convention if no port is specified we use the development port
    ; 8083
    "8083"))

(defn env-port [env-uri-map]
  (get-port
    (get env-uri-map rails/env)))

(defn boot-server []
  (run-jetty app {:port (parse-integer (env-port server-uris))}))

