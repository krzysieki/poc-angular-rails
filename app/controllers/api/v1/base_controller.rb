module Api

  module V1

    class BaseController < ApplicationController
      #protect_from_forgery with: :null_session
      respond_to :json
      doorkeeper_for :all

      def user_signed_in?
        !!current_user
      end

      def current_user
        @current_user ||= warden.authenticate(:scope => :user)
      end

      def user_session
        current_user && warden.session(:user)
      end

    end
  end
end