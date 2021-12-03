# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @title = User.model_name.human
    @users = User.with_attached_avatar.order(:id).page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def followings
    @user  = User.find(params[:id])
    @title = "#{@user.name} #{Relationship.human_attribute_name(:following)}"
    @users = @user.followings.with_attached_avatar.order(:id).page(params[:page])
    render 'index'
  end

  def followers
    @user  = User.find(params[:id])
    @title = "#{@user.name} #{Relationship.human_attribute_name(:followers)}"
    @users = @user.followers.with_attached_avatar.order(:id).page(params[:page])
    render 'index'
  end
end
