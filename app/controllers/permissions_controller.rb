class PermissionsController < ApplicationController
  before_filter :has_login

  def index
    @permissions_grid = initialize_grid(Permission)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @permissions_grid }
    end
  end
end
