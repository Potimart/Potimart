# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_dsl_potimart_session',
  :secret      => '9cf4b01c4360a838c64f6c6a81af1b3be4aece355023ea9bb1698c02e126fb5e79ce0984ce926da64490fe38bd0ee8d118b180c53393d5d4f26be1602e654450'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
