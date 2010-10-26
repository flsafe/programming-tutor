(ns recomendation-engine.database
  (:use [clojure.contrib.sql :only (with-connection with-query-results insert-values)])
  (:use [clojure.contrib.str-utils :only (str-join)])
  (:import (java.sql DriverManager)))

;TODO Turn this in a funciton that return either dev or prod db creds
(def db {:classname "org.sqlite.JDBC"
         :subprotocol "sqlite"
         :subname "../db/development.sqlite3"})

(defn get-ratings []
  "Query the rating records in the db"
  (with-query-results res ["select user_id, exercise_id, rating from ratings"]
                      (doall res)))

(defn to-prefs [db-results]
  "Collapse all the user's ratings into a map"
  (reduce (fn [prefs {user :user_id exercise :exercise_id rating :rating}]
            (assoc prefs user (assoc (prefs user) exercise rating)))
  {{}} db-results))

(defn get-user-prefs []
  "Return a map from user ids to another map of exercise id and rating"
  (with-connection db
    (to-prefs
      (get-ratings))))

(defn now [] (java.sql.Timestamp. (.getTime (java.util.Date.)))) 

(defn to-values [user_id rec-map-seq]
  (str-join "," (for [rec-map rec-map-seq] (:item rec-map))))

;TODO These updates should probably be queued up somehow
(defn save-recomendations [user_id rec-map-seq]
  (with-connection db 
    (let [timestamp (now)]
      (seq 
        (insert-values :recomendations
         [:user_id :exercise_recomendation_list   :created_at :updated_at]
         [user_id  (to-values user_id rec-map-seq) timestamp  timestamp  ])))))

