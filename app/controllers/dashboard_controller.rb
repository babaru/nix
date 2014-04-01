class DashboardController < ApplicationController
  before_filter :has_login

  def index
    @projects_grid = initialize_grid(Project.where('started_at <= ? and ended_at >= ?',Time.now,Time.now))
  end
end
