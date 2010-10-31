(ns recomendation-engine.test.core
  (:use [recomendation-engine.core] :reload)
  (:use [clojure.contrib.math :only [abs]])
  (:use [clojure.test]))

(def prefs-test
  {"Lisa Rose" {"Lady in the Water" 2.5, "Snakes on a Plane" 3.5, 
 "Just My Luck" 3.0, "Superman Returns" 3.5, "You, Me and Dupree" 2.5, 
 "The Night Listener" 3.0}, 
"Gene Seymour" {"Lady in the Water" 3.0, "Snakes on a Plane" 3.5, 
 "Just My Luck" 1.5, "Superman Returns" 5.0, "The Night Listener" 3.0, 
 "You, Me and Dupree" 3.5}, 
"Michael Phillips" {"Lady in the Water" 2.5, "Snakes on a Plane" 3.0, 
 "Superman Returns" 3.5, "The Night Listener" 4.0}, 
"Claudia Puig" {"Snakes on a Plane" 3.5, "Just My Luck" 3.0, 
 "The Night Listener" 4.5, "Superman Returns" 4.0, 
 "You, Me and Dupree" 2.5}, 
"Mick LaSalle" {"Lady in the Water" 3.0, "Snakes on a Plane" 4.0, 
 "Just My Luck" 2.0, "Superman Returns" 3.0, "The Night Listener" 3.0, 
 "You, Me and Dupree" 2.0}, 
"Jack Matthews" {"Lady in the Water" 3.0, "Snakes on a Plane" 4.0, 
 "The Night Listener" 3.0, "Superman Returns" 5.0, "You, Me and Dupree" 3.5}, 
"Toby" {"Snakes on a Plane"4.5,"You, Me and Dupree"1.0,"Superman Returns"4.0}})

(def expected-sim-pearson 
  '({:rating 2.8325499182641614, :item "Lady in the Water"} 
    {:rating 2.530980703765565, :item "Just My Luck"} 
    {:rating 3.3477895267131017, :item "The Night Listener"}))

(def expected-sim-distance
  '({:rating 2.7561242939959363, :item "Lady in the Water"} 
    {:rating 2.461988486074374, :item "Just My Luck"} 
    {:rating 3.5002478401415877, :item "The Night Listener"}))

(def expected-recomendations
  '({:rating 3.3477895267131013, :item "The Night Listener"},
   {:rating 2.8325499182641614, :item "Lady in the Water"}, 
   {:rating 2.5309807037655645, :item "Just My Luck"}))

(def allowed 0.000000001)

(defn diff<= [delta n1 n2]
  (<= (abs (- n1 n2)) delta))

(defn equal-maps? [map-sequence1 map-sequence2]
  (let [matches (for [m1 map-sequence1 m2 map-sequence2 :when (= m1 m2)] m1)]
    (and (= (count map-sequence1) (count map-sequence2) (count matches)))))

(deftest test-pearson-recomendation
  (is
    (diff<= allowed
            (pearson-similarity prefs-test "Lisa Rose" "Gene Seymour")
             0.396059017191)))

(deftest test-pearson-recomendation-no-person
  (is
    (= 0
       (pearson-similarity prefs-test "Lisa Rose" "I don't exisit"))))

(deftest test-get-recomendations 
  (is
    (equal-maps? (get-recomendations prefs-test "Toby" pearson-similarity)
                  expected-recomendations)))

(deftest test-not-reviewed-by
  (let [prefs {:a {:x 1 :y 1} :b {:x 1 :y 1 :z 1}}
        expected [:y :z]]
    (is 
      (= (sort (not-reviewed-by prefs :a))
         '(:z)))))
    
        
