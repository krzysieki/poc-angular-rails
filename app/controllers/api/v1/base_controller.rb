class Api::V1::BaseController < ApplicationController

  doorkeeper_for :all

end