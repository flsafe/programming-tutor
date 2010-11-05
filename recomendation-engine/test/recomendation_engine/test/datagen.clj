(ns recomendation-engine.test.datagen
  (import (java.util Random)))

(defn next-normal-rand [mean sigma]
  (let [r (Random.)]
    (first 
      (take 1 (repeatedly #(-> r .nextGaussian (* sigma) (+ mean)))))))

(defn rand-ratings [num-people num-items]
  (for [person (range 1 (inc num-people))
        item (range 1 (inc num-items))]
    {:u person :i item :r (next-normal-rand 5 7)}))

(defn take-half [person prefs]
  (let [remove-keys (range 1
                           (/
                             (inc (count (prefs person)))
                             2))]
    (apply dissoc
           (prefs person)
           remove-keys)))

(defn rand-prefs [person num-people num-items]
  (let [prefs (reduce #(assoc-in %1 [(:u %2)]
                      (assoc-in (get %1 (:u %2) {}) [(:i %2)] (:r %2))) 
                      {{}}
                      (rand-ratings num-people num-items))]
    (assoc prefs person (take-half person prefs))))
