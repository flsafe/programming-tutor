(ns recomendation-engine.test.datagen)

(defn rand-ratings [num-people num-items]
  (for [person (range 1 (inc num-people))
        item (range 1 (inc num-items))]
    {:u person :i item :r (inc (rand-int 5))}))

(defn rand-prefs [num-people num-items]
  (reduce #(assoc-in %1 [(:u %2)]
                     (assoc-in (get %1 (:u %2) {}) [(:i %2)] (:r %2))) 
          {{}}
          (rand-ratings num-people num-items)))


