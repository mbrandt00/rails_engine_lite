class ApplicationController < ActionController::API
    include QueryDecider

    def current_user 
        User.find(session[:user_id]) if session[:user_id]
    end
end
