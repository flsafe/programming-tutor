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

(defn rand-prefs [num-people num-items]
  (reduce #(assoc-in %1 [(:u %2)]
                     (assoc-in (get %1 (:u %2) {}) [(:i %2)] (:r %2))) 
          {{}}
          (rand-ratings num-people num-items)))


