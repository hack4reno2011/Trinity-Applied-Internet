class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  skip_before_filter :require_basic_auth
  
  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

  def method_missing(provider)
    return if User.omniauth_providers.index(provider).nil?

    #omniauth = request.env["omniauth.auth"]
    omniauth = env["omniauth.auth"]
    
    if current_user #or User.find_by_email(auth.recursive_find_by_key("email"))
      current_user.user_tokens.find_or_create_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
      flash[:notice] = "Authentication successful"
      redirect_to edit_user_registration_path
      return
    end

    authentication = UserToken.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication # already signed up
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => omniauth['provider']
      sign_in_and_redirect(:user, authentication.user)
      return
    end

    #create a new user
    unless omniauth.recursive_find_by_key("email").blank?
      user = User.find_or_initialize_by_email(:email => omniauth.recursive_find_by_key("email"))
    else
      user = User.new
    end
          
    user.apply_omniauth(omniauth)

    if user.save
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => omniauth['provider'] 
      sign_in_and_redirect(:user, user)
    else
      session[:omniauth] = omniauth.except('extra')
      redirect_to new_user_registration_url
    end
  end

end