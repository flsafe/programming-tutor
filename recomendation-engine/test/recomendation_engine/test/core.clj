(ns recomendation-engine.test.core
  (:use [recomendation-engine.core] :reload)
  (:use [clojure.test]))

(def expected-sim-pearson 
  '({:rating 2.8325499182641614, :item "Lady in the Water"} 
    {:rating 2.530980703765565, :item "Just My Luck"} 
    {:rating 3.3477895267131017, :item "The Night Listener"}))

(def expected-sim-distance
  '({:rating 2.7561242939959363, :item "Lady in the Water"} 
    {:rating 2.461988486074374, :item "Just My Luck"} 
    {:rating 3.5002478401415877, :item "The Night Listener"}))

(defn equal-maps? [map-sequence1 map-sequence2]
  (let [matches (for [m1 map-sequence1 m2 map-sequence2 :when (= m1 m2)] m1)]
    (and (= (count map-sequence1) (count map-sequence2) (count matches)))))

(deftest test-get-recomendations-pearson
         (is (equal-maps? (get-recomendations "Toby" pearson-similarity) expected-sim-pearson)))

(deftest test-get-recomendations-distance
         (is (equal-maps? (get-recomendations "Toby" distance-similarity) expected-sim-distance))) 
