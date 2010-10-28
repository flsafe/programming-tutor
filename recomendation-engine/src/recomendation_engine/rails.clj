(ns recomendation-engine.rails
  (:require [clj-yaml.core :as yaml]))

(def env
  (or (keyword (System/getenv "RAILS_ENV")) :development)) 

(defn db 
  [rails-env]
  (rails-env
    (yaml/parse-string 
      (slurp "../config/database.yml"))))

(defn subprotocol
  "Return a map with :subprotocol mapping
  to the rails db :adapter"
  [rails-db-config]
  (:adapter rails-db-config))

(defn proj-relative
  "Returns true if the database name is
   a file relative to the rails root dir"
  [rails-db-config]
  (not= 
    -1 
    (.indexOf (:adapter rails-db-config) "sqlite")))

(defn subname
  "Return a map with subname mapping to
   //host/database"
  [rails-db-config]
  (if (proj-relative rails-db-config)
    (str "//"  "/.." "/" (:database rails-db-config))
    (str "//" (:host rails-db-config) "/" (:database rails-db-config))))

(defn classname
  "Return a map with :classname mapping to the jdbc class to load"
  [rails-db-config]
  (let [adapter-to-class {"sqlite3"    "org.sqlite.JDBC"
                          "mysql"      "com.mysql.jdbc.Driver"
                          "postgresql" "org.postgresql.Driver"}]
    (adapter-to-class (:adapter rails-db-config))))

(defn db-to-jdbc 
  "Returns a db map with db credentials from 
   rails-project/config/database.yml suitable for use with
   clojure.contirb.sql/with-connection"
  [db-config rails-env]
   {:classname   (classname   (db rails-env))
    :subprotocol (subprotocol (db rails-env))
    :subname     (subname     (db rails-env))
    :user        (:username db-config)
    :password    (:password db-config)})

(defn db-config-to-jdbc
  "Returns a map for use with clojure.contrib.sql/with-connection
   parsed from <rails-proj-root>/config.database.sql and the
   current value of RAILS_ENV"
  []
  (db-to-jdbc (db env) env))
