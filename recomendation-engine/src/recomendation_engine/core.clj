(ns recomendation-engine.core
  (:use [clojure.contrib.math :only [expt]])
  (:use [clojure.contrib.math :only [sqrt]])
  (:use [clojure.contrib.seq  :only [indexed]])
  (:use [clojure.contrib.str-utils :only [str-join]])
  (:use [clojure.pprint])
  (:use [clojure.set :only [difference]])
  (:use [clojure.set :only [intersection]])
  (:require [clojure.pprint :as cljprint]))

(def *prefs* {{}})

(defn rating-diff [prefs person other item] 
  (- (get-in prefs [person item] 0)
     (get-in prefs [other item] 0)))

(defn reviewed-by-both [prefs person other]
  (let [person-items (set (keys (prefs person)))
        other-items  (set (keys (prefs other)))]
    (intersection person-items other-items)))

(defn sum-diffs-squared [prefs person1 person2]
  (reduce + (map #(expt (rating-diff prefs person1 person2 %) 2)
                  (reviewed-by-both prefs person1 person2))))

(defn distance-similarity [person1 person2]
  (/ 1.0 (+ 1.0 (sum-diffs-squared *prefs* person1 person2))))


(defn pearson-similarity [person other]
  (let [common (reviewed-by-both *prefs* person other)]
    (if (> (count common) 0)
      (let [sum1 (reduce + (for [item common] (get-in *prefs* [person item] 0)))
            sum2 (reduce + (for [item common] (get-in *prefs* [other item] 0)))

            sum1sq (reduce + (map #(expt (get-in *prefs* [person %] 0) 2) 
                                  common))
            sum2sq (reduce + (map #(expt (get-in *prefs* [other  %] 0) 2)
                                  common))

            psum   (reduce + (map #(* (get-in *prefs* [person %] 0) 
                                      (get-in *prefs* [other  %] 0))
                                  common))

            numer    (- psum (/ (* sum1 sum2)
                                (count common)))
            denom    (sqrt (*
                             (- sum1sq 
                                (/ (expt  sum1 2)
                                   (count common)))
                            
                             (- sum2sq 
                                (/ (expt  sum2 2)
                                   (count common)))))]
          (if (= denom 0) 0 (/ numer denom)))
        0)))

(defn who-reviewed [prefs items]
  (set 
    (for [person (keys prefs)
        item items
        :when (> (get-in prefs [person item] 0) 0)]
    person)))

(defn not-reviewed-by [prefs person]
  (let [all-items (set 
                    (reduce concat
                            (for [other (keys prefs)] 
                              (keys (prefs other)))))
        reviewed-items (set (keys (prefs person)))]
    (difference all-items reviewed-items)))
    
(defn sum-rating*sim [prefs person item others simfn]
  (reduce + 
        (map #(* (get-in prefs [% item] 0)
                 (simfn person %))
             others)))

(defn sum-sim [prefs person item others simfn]
  (reduce + 
          (map #(simfn person %)
               (filter #(> (get-in prefs
                                   [% item] 
                                   0)
                           0)
                        others))))

(def simfn pearson-similarity)

(defn get-recomendations [prefs person simfnc]
  (if (get prefs person)
    (filter #(not= % nil)
      (binding [simfn (memoize simfnc)
                *prefs* prefs]
        (let [items (not-reviewed-by prefs person)
              others (for [other (who-reviewed prefs items)
                           :when (> (simfn person other) 0)]
                       other)]
          (reverse
            (sort-by :rating
                   (for [item items]
                     (let [numer (sum-rating*sim prefs person item others simfn)
                           denom (sum-sim prefs person item others simfn)]
                       (if (not= denom 0)
                          {:rating (/ (sum-rating*sim prefs person item others simfn)
                                      (sum-sim prefs person item others simfn))
                           :item item}))))))))
    '()))
