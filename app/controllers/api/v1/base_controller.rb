module Api

  module V1

    class BaseController < ApplicationController
      #protect_from_forgery with: :null_session
      respond_to :json

      rescue_from Exception, with: :generic_exception if Rails.env.production?

      rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

      doorkeeper_for :all, unless: :public_endpoint?

      def user_signed_in?
        !!current_user
      end

      def current_user
        @current_user ||= warden.authenticate(:scope => :user)
      end

      def user_session
        current_user && warden.session(:user)
      end

      def doorkeeper_unauthorized_render_options
        {:json => {:error => "Not authorized"}}
      end

      protected

      def public_endpoint?
        public_endpoints = [
            { controller: 'users', action: 'create' }
        ]
        public_endpoints.map{ |endpoint| endpoint[:controller] == controller_name && endpoint[:action] == action_name }.include?(true)
      end

      def record_not_found(error)
        respond_to do |format|
          format.json { render :json => {:error => error.message}, :status => 404 }
        end
      end

      def generic_exception(error)
        respond_to do |format|
          #format.json { render :json => {:error => error.message}, :status => 500 }
          format.json { render :json => {:error => "An error occured. Please contact system admin."}, :status => 500 }
        end
      end

    end
  end
end