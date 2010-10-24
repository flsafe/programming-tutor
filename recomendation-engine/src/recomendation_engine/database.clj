(ns recomendation-engine.database
  (:use [clojure.contrib.sql :only (with-connection with-query-results)])
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
