(ns recomendation-engine.core
  (:use [clojure.contrib.math :only [expt]])
  (:use [clojure.contrib.math :only [sqrt]])
  (:use [clojure.contrib.seq  :only [indexed]])
  (:use [clojure.contrib.str-utils :only [str-join]])
  (:use [clojure.pprint])
  (:use [clojure.set :only [difference]])
  (:require [clojure.pprint :as cljprint]))

(def *similarity-map* {{}})

(defn rating-diff [prefs person1 person2 item] 
  (- ((prefs person1) item) ((prefs person2) item)))

(defn reviewed-by-both [prefs person1 person2]
  (for [item (keys (prefs person1)) :when ((prefs person2) item)] item))

(defn sum-diffs-squared [prefs person1 person2]
  (reduce + (map #(expt (rating-diff prefs person1 person2 %) 2)
                  (reviewed-by-both prefs person1 person2))))

(defn distance-similarity [prefs person1 person2]
  (/ 1.0 (+ 1.0 (sum-diffs-squared prefs person1 person2))))

(defn sum-ratings [prefs person1 items]
  (reduce + (for [item items] ((prefs person1) item))))

(defn sum-ratings**2 [prefs person1 items]
  (reduce + (map #(expt % 2) (for [item items] ((prefs person1) item)))))

(defn sum-rating*prod [prefs person1 person2]
  (reduce + (for [item (reviewed-by-both prefs person1 person2)]
                 (* ((prefs person1) item) ((prefs person2) item)))))

(defn pearson-similarity [prefs p1 p2]
  (let [common-items (reviewed-by-both prefs p1 p2)
        sum1 (sum-ratings prefs p1 common-items)
        sum2 (sum-ratings prefs p2 common-items)
        sum1Sq (sum-ratings**2 prefs p1 common-items)
        sum2Sq (sum-ratings**2 prefs p2 common-items)
        pSum (sum-rating*prod prefs p1 p2)
        common-count (count common-items)

        numer (- pSum (/ (* sum1 sum2) common-count))
        denom (sqrt (* (- sum1Sq (/ (expt sum1 2) common-count))
                       (- sum2Sq (/ (expt sum2 2) common-count))))]
    (if (= denom 0) 0 (/ numer denom))))

(defn top-matches [prefs person number sim-fn]
  (take number (sort #(> (:similarity %1) (:similarity %2)) 
         (for [other-person (keys prefs) :when (not (= other-person person))]
          {:similarity (sim-fn prefs person other-person) 
           :other-person other-person}))))

(defn who-reviewed [prefs item]
  (for [person (keys prefs) 
        :when (>= (get-in prefs [person item] 0) 0)] 
    person))

(defn sum-similarity*rating [prefs person item sim-fn]
  (reduce + (for [other-person (who-reviewed prefs item) 
                  :when (not (= other-person person))]
              (* (max (sim-fn prefs person other-person) 0) 
                 (get (prefs other-person) item 0)))))

(defn sum-similarity [prefs person item sim-fn]
  (reduce + (for [other-person (who-reviewed prefs item) 
                  :when (not (= other-person person))]
              (max (sim-fn prefs person other-person) 0))))

(defn not-reviewed-by [prefs person]
  (let [item-set (set (for [other-person (keys prefs) 
                            item (keys (prefs other-person))] 
                        item))
        items-reviewed-by-person (set (keys (prefs person)))]
    (difference item-set items-reviewed-by-person)))

(defn get-recomendations [prefs person sim-fn]
  (reverse
    (sort-by :rating
             (for [item (not-reviewed-by prefs person)]
                {:rating (/ (sum-similarity*rating prefs person item sim-fn) 
                            (sum-similarity prefs person item sim-fn))
                 :item item}))))

;; New way


(defn all-pairs [coll]
  (let [vect (vec coll)]
    (for [[idx elmt]  (indexed vect)
           other-elmt (subvec vect (inc idx))]
      (vector elmt other-elmt))))

(defn merge-keys [map-sq]
  (reduce 
    #(merge-with merge %1 %2)
    {{}}
    map-sq))

(defn build-similarity-map [prefs simfn]
  (merge-keys
    (for [[person other] (all-pairs (sort (keys prefs)))]
      (assoc-in 
        {} 
        [person other] 
        (simfn prefs person other)))))

(defn get-similarity [person other]
  (let [in-order (sort (vector person other))]
    (pprint in-order)
    (pprint *similarity-map*)
    (get-in *similarity-map* [(first in-order )(second in-order)] 0)))

(defn sum-sim [prefs person reviewers]
  (reduce +
    (for [other reviewers]
      (do 
        (println (str-join "," [person other]))
        (get-similarity person other)))))

(defn sum-sim*rating [prefs person reviewers item]
  (reduce +
    (for [other reviewers]
      (* (get-similarity person other)
         (get-in prefs [other item] 0)))))

(defn get-recs [prefs person simfn]
  (binding [*similarity-map* (build-similarity-map prefs simfn)]
    (for [item  (not-reviewed-by prefs person)]
      {:rating (/
                 (sum-sim*rating prefs person (who-reviewed prefs item) item)
                 (sum-sim        prefs person (who-reviewed prefs item)))
       :item item})))
