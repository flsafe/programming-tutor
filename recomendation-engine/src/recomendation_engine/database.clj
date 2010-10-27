(ns recomendation-engine.database
  (:use [clojure.contrib.sql :only (with-connection with-query-results insert-values)])
  (:use [clojure.contrib.str-utils :only (str-join)])
  (:require [clj-yaml.core :as yaml])
  (:import (java.sql DriverManager)))

(def rails-env
  (or (keyword (System/getenv "RAILS_ENV")) :development)) 

(def rails-db-config
  (rails-env
    (yaml/parse-string 
      (slurp "../config/database.yml"))))

;TODO Turn this in a funciton that return either dev or prod db creds
(def db {:classname "org.sqlite.JDBC"
         :subprotocol "sqlite"
         :subname "../db/development.sqlite3"})

(defn get-ratings 
  "Returns a realized sequence of all ratings in the db"
  []
  (with-query-results res ["select user_id, exercise_id, rating from ratings"]
                      (doall res)))

(defn to-prefs
  "Collapse all the user's ratings to a map mapping exercise_id to rating"
  [db-results]
  (reduce (fn [prefs {user :user_id exercise :exercise_id rating :rating}]
            (assoc prefs user (assoc (prefs user) exercise rating)))
  {{}} db-results))

(defn get-user-prefs 
  "Return a map mapping user_ids to a map of exercise id to rating"
  []
  (with-connection db
    (to-prefs
      (get-ratings))))

(defn now [] (java.sql.Timestamp. (.getTime (java.util.Date.)))) 

(defn to-values 
  "Return a commna delimited string containing
   recomended exercise ids"
  [rec-map-seq]
  (str-join "," (for [rec-map rec-map-seq] (:item rec-map))))

;TODO These updates should probably be queued up somehow
(defn save-recomendations 
  "Save the recomendations to the database using
   the given user_id and recomendation-map sequence"
  [user_id rec-map-seq]
  (with-connection db 
    (let [timestamp (now)]
      (seq 
        (insert-values :recomendations
         [:user_id :exercise_recomendation_list   :created_at :updated_at]
         [user_id  (to-values rec-map-seq)        timestamp   timestamp  ])))))

