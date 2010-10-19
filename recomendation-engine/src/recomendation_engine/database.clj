(ns recomendation-engine.database
  (:use [clojure.contrib.sql :only (with-connection with-query-results)])
  (:import (java.sql DriverManager)))

(def db {:classname "org.sqlite.JDBC"
         :subprotocol "sqlite"
         :subname "../db/development.sqlite3"})

(defn print-in-db []
  (with-query-results res ["select * from users"]
    (doall res)))
