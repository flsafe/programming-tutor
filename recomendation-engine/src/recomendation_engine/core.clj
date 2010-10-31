(ns recomendation-engine.core
  (:use [clojure.contrib.math :only [expt]])
  (:use [clojure.contrib.math :only [sqrt]])
  (:use [clojure.contrib.seq  :only [indexed]])
  (:use [clojure.contrib.str-utils :only [str-join]])
  (:use [clojure.pprint])
  (:use [clojure.set :only [difference]])
  (:require [clojure.pprint :as cljprint]))

(defn rating-diff [prefs person1 person2 item] 
  (- ((prefs person1) item) ((prefs person2) item)))

(defn reviewed-by-both [prefs person1 person2]
  (for [item (keys (prefs person1)) :when ((prefs person2) item)] item))

(defn sum-diffs-squared [prefs person1 person2]
  (reduce + (map #(expt (rating-diff prefs person1 person2 %) 2)
                  (reviewed-by-both prefs person1 person2))))

(defn distance-similarity [prefs person1 person2]
  (/ 1.0 (+ 1.0 (sum-diffs-squared prefs person1 person2))))

(defn sum-ratings [prefs person items]
  (reduce + (for [item items]
              (get-in prefs [person item] 0))))

(defn pearson-similarity [prefs person other]
  (let [common (reviewed-by-both prefs person other)]
    (if (> (count common) 0)
      (let [sum1 (sum-ratings prefs person common)
            sum2 (sum-ratings prefs other  common)

            sum1sq (reduce + (map #(expt (get-in prefs [person %] 0) 2) 
                                  common))
            sum2sq (reduce + (map #(expt (get-in prefs [other  %] 0) 2)
                                  common))

            psum   (reduce + (map #(* (get-in prefs [person %] 0) 
                                      (get-in prefs [other  %] 0))
                                  common))

            numer    (- psum (/ (* sum1 sum2)
                                (count common)))
            denom    (sqrt (*
                             (/ 
                               (- sum1sq (expt  sum1 2))
                               (count common))
                             (/ 
                               (- sum2sq (expt  sum2 2))
                               (count common))))]
        (println (str "sum1: " sum1 " sum2: " sum2 " sum1sq: " sum1sq " sum2sq: " sum2sq " psum: " psum " numer: " numer " denom: " denom))
        (if (= denom 0) 0 (/ numer denom)))
        0)))
