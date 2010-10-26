(ns recomendation-engine.app
  (:use recomendation-engine.database)
  (:use recomendation-engine.core))

(def *user-prefs*
  (atom (get-user-prefs)))

(defn add-rating [{user :user_id exercise :exercise_id rating :rating}]
  (reset! *user-prefs* (assoc-in @*user-prefs* [user exercise] rating)))

(defn handle-rating [rating]
  (add-rating rating))
