# Use ActiveRecord session store for large session data
Rails.application.config.session_store :active_record_store, key: "_rapi_deck_session"
