(ns recomendation-engine.core
  (:use [clojure.contrib.math :only [expt]])
  (:use [clojure.contrib.math :only [sqrt]])
  (:use [clojure.set :only [difference]]))

(def prefs
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

(defn rating-diff [person1 person2 item] 
  (- ((prefs person1) item)
     ((prefs person2) item)))

(defn reviewed? [person item] ((prefs person) item))

(defn reviewed-by-both [person1 person2]
  (for [item (keys (prefs person1)) :when (reviewed? person2 item)] item))

(defn sum-diffs-squared [person1 person2]
  (reduce + (map #(expt (rating-diff person1 person2 %1) 2)
                  (reviewed-by-both person1 person2))))

(defn distance-similarity [person1 person2]
  (/ 1.0 (+ 1.0 (sum-diffs-squared person1 person2))))

(defn sum-ratings [person1 items]
  (reduce + (for [item items] ((prefs person1) item))))

(defn su-ratings**2 [person1 items]
  (reduce + (map #(expt % 2) 
                 (for [item items] ((prefs person1) item)))))

(defn sum-rating*prod [person1 person2]
  (reduce + (for [item (reviewed-by-both person1 person2)]
                 (* ((prefs person1) item) ((prefs person2) item)))))

(defn pearson-similarity [p1 p2]
  (let [common-items (reviewed-by-both p1 p2)
        sum1 (sum-ratings p1 common-items)
        sum2 (sum-ratings p2 common-items)
        sum1Sq (su-ratings**2 p1 common-items)
        sum2Sq (su-ratings**2 p2 common-items)
        pSum (sum-rating*prod p1 p2)
        common-count (count common-items)

        numer (- pSum (/ (* sum1 sum2) common-count))
        denom (sqrt (* (- sum1Sq (/ (expt sum1 2) common-count))
                       (- sum2Sq (/ (expt sum2 2) common-count))))]
    (if (= denom 0) 0 (/ numer denom))))

(defn top-matches [person number sim-fn]
  (take number (sort #(> (:similarity %1) (:similarity %2)) 
         (for [other-person (keys prefs) :when (not (= other-person person))]
          {:similarity (sim-fn person other-person) :other-person other-person}))))

(defn who-reviewed [item]
  (for [person (keys prefs) :when (reviewed? person item)]
    person))

(defn sum-similarity*rating [person item sim-fn]
  (reduce + (for [other-person (who-reviewed item)]
              (* (max (sim-fn person other-person) 0) (get (prefs other-person) item 0)))))

(defn sum-similarity [person item sim-fn]
  (reduce + (for [other-person (who-reviewed item)]
              (max (sim-fn person other-person) 0))))

(defn not-reviewed-by [person]
  (let [item-set (set (for [person (keys prefs) item (keys (prefs person))] item))
        items-reviewed-by-person (set (keys (prefs person)))]
    (difference item-set items-reviewed-by-person)))

(defn get-recomendations [person sim-fn]
  (for [item (not-reviewed-by person)]
    {:rating (/ (sum-similarity*rating person item sim-fn) 
                (sum-similarity person item sim-fn))
     :item item}))
