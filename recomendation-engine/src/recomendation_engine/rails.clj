
(def rails-env
  (or (keyword (System/getenv "RAILS_ENV")) :development)) 

(def rails-db-config
  (rails-env
    (yaml/parse-string 
      (slurp "../config/database.yml"))))
