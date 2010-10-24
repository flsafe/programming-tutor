(ns recomendation-engine.test.database
  (:use [recomendation-engine.database] :reload)
  (:use [clojure.test]))

(def input-db-record 
  '({:user_id 1 :exercise_id 1 :rating 3}
   {:user_id 1 :exercise_id 2 :rating 3}
   {:user_id 2 :exercise_id 1 :rating 3}
   {:user_id 2 :exercise_id 2 :rating 3}
   {:user_id 3 :exercise_id 2 :rating 3}))

(def expected-prefs 
  {1 {1 3 2 3}
   2 {1 3 2 3}
   3 {2 3}})

(deftest test-to-prefs
  (is (to-prefs input-db-record) expected-prefs))

