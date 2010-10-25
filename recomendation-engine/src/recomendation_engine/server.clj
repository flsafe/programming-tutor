(ns recomendation-engine.server
  (:use ring.adapter.jetty)
  (:use ring.middleware.params)
  (:use ring.middleware.stacktrace)
  (:use ring.middleware.reload)
  (:use recomendation-engine.database)
  (:use recomendation-engine.core)
  (:use clojure.contrib.str-utils))

(def *user-prefs*
  (ref (get-user-prefs)))

(defn add-user-rating [prefs {user :user_id exercise :exercise_id rating :rating}]
  (let [user-ratings (get prefs user {})]
    (assoc user-ratings exercise rating)))

(defn add-rating [rating]
    (dosync 
      (alter *user-prefs* assoc (:user_id rating) (add-user-rating @*user-prefs* rating))))

(defn build-response [request]
  (str-join "<br/>" ["<h1>CozyRecomendations Server</h1>" 
                     "User Preferences"
                     (str @*user-prefs*)
                     "Request"
                     (str request)]))

(defn new-rating? [{params :params}]
  (and (params "user_id")
       (params "exercise_id")
       (params "rating")))

(defn parse-integer [str]
  (try (Integer/parseInt str) 
       (catch NumberFormatException nfe 0)))

(defn build-rating [{params :params}]
  {:user_id (parse-integer (params "user_id"))
   :exercise_id (parse-integer (params "exercise_id"))
   :rating (parse-integer (params "rating"))})

(defn new-rating [request]
  {:status  200
   :headers {"Content-Type" "text/html"}
   :body    (do 
              (if (new-rating? request)
                (add-rating (build-rating request)))
              (build-response request))})
         
;TODO wrap-reload, wrap-stacktrace are only for dev
(def app
  (-> #'new-rating
    (wrap-reload '(recomendation-engine.server))
    (wrap-params)
    (wrap-stacktrace)))
    
(defn boot-server []
  (run-jetty app {:port 8080}))

