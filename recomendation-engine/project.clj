(defproject recomendation-engine "1.0.0-SNAPSHOT"
  :description "Recomends exercises to users"

  :dependencies [[org.clojure/clojure "1.2.0"]
                 [org.clojure/clojure-contrib "1.2.0"]
                 [ring/ring-core "0.3.2"]
                 [ring/ring-jetty-adapter "0.3.2"]]

  :dev-dependencies [[org.clojars.gfodor/lein-nailgun "1.1.0"]
                     [sqlitejdbc "0.5.6"]
                     [ring/ring-devel "0.3.2"]])
