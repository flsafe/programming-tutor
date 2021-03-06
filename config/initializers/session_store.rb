# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_blueberryrow_session',
  :secret      => 'b310eb6d96f6e405b883b123181353b9d213cde30701c04a4656c62f0d0f62ec2a268f374a99388c867da19e1adaf801b601ab7a777e79d193c19ca3225d371d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
