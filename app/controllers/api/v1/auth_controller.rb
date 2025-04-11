module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authorized, only: [:signup, :login]
      def signup
        user = User.new(user_params)
        user.password = BCrypt::Password.create(user_params[:password])
        user.image.attach(user_params[:image]) if user_params[:image].present?

        user.save!

        render json: {
          success: true,
          message: "User created successfully",
          data: {
            id: user.id,
            name: user.name,
            email: user.email,
            image_url: user.image.attached? ? rails_blob_url(user.image) : nil
          }
        }, status: :created
      end

      def login
        user = User.find_by(email: login_params[:email])
        if user && user.authenticate(login_params[:password])
          token = encode_token({user_id: user.id})
          render json: {
            success: true,
            message: "Logged in successfully",
            data: {
              token: token,
              user_id: user.id,
              email: user.email,
              name: user.name, image_url: user.image.attached? ? rails_blob_url(user.image) : nil
            }
          }, status: :ok
        else
          render json: {success: false, message: "Invalid email or password", status: 401}, status: :unauthorized
        end
      end

      private

      def user_params
        params.permit(:name, :email, :password, :image)
      end

      def login_params
        params.permit(:email, :password)
      end

    end
  end
end
