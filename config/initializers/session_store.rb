# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_schoolarly_session',
  :secret      => 'e515c8df6f0c4b5caa3a66204156db85c4bd961a80230b1fa2b9debe6c2e92fd2f3928d1415749679d106d0f4980a5a0eab12acd6e66d7f9ebd22b00df5f5e87'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
