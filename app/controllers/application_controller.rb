# SessionHandler stores and retrieves values from session.
#
# ==== Examples
#
#   > session_handler.set(:foo,"bar")
#   > session_handler.get(:foo)
#   # => "bar"
#   # +session+ {foo: {value: "bar" }}
#
#   > session_handler.set([:foo,:bar], "bar2")
#   > session_handler.get(:foo)
#   # => "bar2"
#   # +session+ {foo: {value: "bar" }, foo2: {value: "bar2"}}
#
class SessionHandler
  attr_reader :session
  @@handler = nil

  def set_session session
    @session = session
    self
  end

  # Initiate or return the singleton object
  def self.get
    @@handler ||= SessionHandler.new
  end
  
  def set keys, value
    do_set(session, keys, value)
  end
  
  def get keys
    do_get(session, keys)
  end

  # Recursively set the value to the session
  def do_set current, keys, value
    if keys.blank?
      current[:value] = value
      return current
    end

    keys = [keys] unless keys.is_a? Array
    current_key = keys.shift.to_sym
    if current[current_key].blank?
      current[current_key] = {:value => {}}
    end
    
    if keys.size > 0
      current[current_key] = do_set(current[current_key], keys, value)
    else
      current[current_key][:value] = value      
    end
    
    current
  end

  # Recursively find the value from the session.
  def do_get current, keys    
    keys = [keys] unless keys.is_a? Array
    if keys.blank?
      if current.is_a?(Hash) and current.has_key?(:value)
        return current[:value]
      elsif current.is_a?(Hash) and current.has_key?("value")
        return current["value"]
      else
        return current
      end
    end
    current_key = keys.shift
    if current[current_key].blank?
      current[current_key]
    else
      do_get(current[current_key], keys)
    end
  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_locale

  # Guest user code from:
  # https://github.com/plataformatec/devise/wiki/How-To:-Create-a-guest-user
  #
  # if user is logged in, return current_user, else return guest_user
  def current_or_guest_user
    if current_user
      if session[:guest_user_id] && session[:guest_user_id] != current_user.id
        logging_in
        # reload guest_user to prevent caching problems before destruction
        #guest_user(with_retry = false).try(:reload).try(:destroy)
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  # find guest_user object associated with the current session,
  # creating one as needed
  def guest_user(with_retry = true)
    # Cache the value the first time it's gotten.
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)

  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
    session[:guest_user_id] = nil
    guest_user if with_retry
  end

  private

  def session_handler
    SessionHandler.get.set_session(session)    
  end

  # called (once) when the user logs in, insert any code your application needs
  # to hand off from guest_user to current_user.
  def logging_in
    # For example:
    # guest_comments = guest_user.comments.all
    # guest_comments.each do |comment|
    # comment.user_id = current_user.id
    # comment.save!
    # end
  end

  def create_guest_user
    u = User.create(:username => "guest", :email => "guest_#{Time.now.to_i}#{rand(100)}@suorademokratia.net")
    u.save!(:validate => false)
    session[:guest_user_id] = u.id
    u
  end
  
  def set_locale
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end
  
end
