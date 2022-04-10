class Api::V1::RegistrationsController < ApplicationController
    def create 
        user = User.create!(
            email: params[:email], 
            password: params[:password], 
            password_confirmation: params[:password_confirmation],
            type_of_user: params[:type_of_user].downcase
        )
        if user 
            session[:user_id] = user.id 
            render json: {
                status: :created, 
                user: user
            }
        else 
            render json: {status: 500}
        end
    end
end