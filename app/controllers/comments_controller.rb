# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[update destroy edit]
  before_action :correct_user, only: %i[update destroy]

  def create
    comment = @commentable.comments.new comment_params
    comment.user_id = current_user.id
    if comment.save
      name = Comment.model_name.human
      flash[:notice] = t('controllers.common.notice_create', name: name)
    else
      flash[:alert] = comment.errors.full_messages.first
    end
    redirect_to @commentable
  end

  def destroy
    @comment.destroy
    redirect_to @commentable, notice: t('controllers.common.notice_destroy', name: Book.model_name.human)
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      redirect_to @commentable, notice: t('controllers.common.notice_update', name: Comment.model_name.human)
    else
      render :edit
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def correct_user
    return if @comment.user_id == current_user.id

    render status: :forbidden, json: { status: :forbidden, message: t('errors.messages.forbidden') }
  end
end
