(ns recomendation-engine.test.rails
  (:require [recomendation-engine.rails :as rails])
  (:use [clojure.test :only (deftest is)])) 

(def rails-dev-db-config-sqlite
  {:adapter  "sqlite3"
   :database "db/development.sqlite3"
   :timeout  5000})

(def expected-dev-jdbc-config-sqlite
  {:classname   "org.sqlite.JDBC"
   :subprotocol "sqlite"
   :subname     "../db/development.sqlite3"
   :timeout     5000
   :user        nil
   :password    nil})
  
(def rails-prod-db-config
  {:adapter  "mysql"
   :database "blueberrytree"
   :username "blueberrytree"
   :password "passpass"
   :host     "localhost"})

(def expected-prod-jdbc-config
  {:classname   "com.mysql.jdbc.Driver"
   :subprotocol "mysql"
   :subname     "//localhost/blueberrytree"
   :user        "blueberrytree"
   :password    "passpass"})

(deftest test-dev-config-sqlite
   (is 
     (= 
       (rails/db-to-jdbc rails-dev-db-config-sqlite :development)
        expected-dev-jdbc-config-sqlite)))
