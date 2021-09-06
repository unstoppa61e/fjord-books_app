class UsersController < ApplicationController
  def index
    @users = User.order(:created_at, :id).page(params[:page])
  end

  def show
  end
end
