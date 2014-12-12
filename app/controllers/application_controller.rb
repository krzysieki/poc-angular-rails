class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
end

# remove below code before deploy to prod
module PunditHelper
  extend ActiveSupport::Concern

  private

  def user_not_authorized
    flash[:alert] = "Access denied."
    redirect_to (request.referrer || root_path)
  end

end

ApplicationController.send :include, PunditHelper
