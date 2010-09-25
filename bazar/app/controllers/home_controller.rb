class HomeController < ApplicationController

  # before_filter :require_no_user
  before_filter :require_user, :only => [:index]
  # before_filter :require_user
  
  def index
  end

end
