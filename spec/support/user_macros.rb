module UserMacros
  module Controller
    # ==== Examples
    #   # Pass a User instance explicitly
    #   login(create(:user))

    #   # Invoke directly, will create a user, login it and return itself.
    #   user = login
    def login(user = nil)
      user = user || create(:user)
      session[:user_id] = user.id

      user
    end
  end
end
