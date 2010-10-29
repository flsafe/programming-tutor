(ns recomendation-engine.core
  (:use [clojure.contrib.math :only [expt]])
  (:use [clojure.contrib.math :only [sqrt]])
  (:use [clojure.contrib.seq  :only [indexed]])
  (:use [clojure.set :only [difference]]))


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
        :when ((prefs person)item)] 
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

(defn sum-sim [prefs person simfn]
  (reduce +
    (for [other-person  (keys prefs)
          similarity   `(~(simfn prefs other-person person))
          :when         (and (not= other-person person) (> similarity 0))]
      similarity)))

(defn item-difference [prefs person other-person]
  (let [person-set       (set (keys (prefs person)))
        other-person-set (set (keys (prefs other-person)))]
    (difference person-set other-person-set)))

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

(defn get-similarity [sim-map person other]
  (let [in-order (sort (vector person other))]
    (get-in sim-map [(first in-order )(second in-order)] 0)))
