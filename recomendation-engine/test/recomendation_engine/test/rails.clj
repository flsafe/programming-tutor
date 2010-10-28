(ns recomendation-engine.test.rails
  (:require [recomendation-engine.rails :as rails])
  (:use [clojure.test :only (deftest is)])) 

(def rails-dev-db-config
  {:adapter  "sqlite3"
   :database "db/development.sqlite3"})

(def expected-dev-jdbc-config
  {:classname   "org.sqlite.JDBC"
   :subprotocol "sqlite3"
   :subname     "///../db/development.sqlite3"
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

(deftest test-dev-config
   (is 
     (= 
       (rails/db-to-jdbc rails-dev-db-config :development)
        expected-dev-jdbc-config)))
