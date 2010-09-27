class UserController < ApplicationController
  before_filter :require_user
end
