(ns recomendation-engine.test.server
  (:require [recomendation-engine.server :as server])
  (:use [clojure.test :only (deftest is)])) 

(def recomendation-server-uri 
  {:production "http://localhost:8080"
   :staging "http://staging.blueberrytree.ws:8081/test/me"
   :typo "http://localhost:"
   :development "http://locahost:8083"})

(def expected-ports
  {:production "8080"
   :staging "8081"
   :typo "8083" ; Defaults to development port 8083
   :development "8083"}) 
                         
(deftest test-get-port-production
   (is 
     (= 
       (server/get-port (get recomendation-server-uri :production)) 
        (expected-ports :production))))

(deftest test-get-port-staging
    (is
      (=
        (server/get-port (get recomendation-server-uri :staging))
        (expected-ports :staging))))

(deftest test-get-port-typo
    (is
      (=
        (server/get-port (get recomendation-server-uri :typo))
        (expected-ports :typo))))

(deftest test-env-port
    (is
      (=
        (server/env-port recomendation-server-uri)
        (expected-ports :development))))
