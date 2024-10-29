# frozen_string_literal: true

module Users
  class ProfileController < ApplicationController
    before_action :load_user, only: [:show, :update, :destroy]

    def index
      users = User.all

      render(jsonapi: users)
    end

    def show
      render(jsonapi: @user)
    end

    def create
      user = User.new(user_params)

      with_model_errors_handling do
        user.save!

        render(jsonapi: user, status: :created)
      end
    end

    def update
      with_model_errors_handling do
        @user.update!(user_params)

        render(jsonapi: @user)
      end
    end

    def destroy
      with_model_errors_handling do
        @user.destroy!

        head(:no_content)
      end
    end

    private

    def load_user
      @user = if params[:id] == "me" && current_user.present?
        current_user
      else
        User.find(params[:id])
      end
    end

    def user_params
      params.require(:user).permit(:email, :time_zone)
    end
  end
end
