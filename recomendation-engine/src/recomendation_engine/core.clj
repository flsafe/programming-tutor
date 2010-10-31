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
    (if (> 0 (count common))
      (let [sum1 (sum-ratings prefs person common)
            sum2 (sum-ratings prefs other  common)]
        0)
      0)))
