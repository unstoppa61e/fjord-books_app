# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[update destroy edit]
  before_action :correct_user, only: %i[update destroy]

  def create
    comment = @commentable.comments.new comment_params
    comment.user_id = current_user.id
    if comment.save
      name = Comment.model_name.human
      redirect_to @commentable, notice: t('controllers.common.notice_create', name: name)
    else
      redirect_to @commentable, alert: "#{Comment.model_name.human}#{t 'errors.messages.blank'}"
    end
  end

  def destroy
    if @comment.destroy
      redirect_to @commentable, notice: t('controllers.common.notice_destroy', name: Book.model_name.human)
    else

    end
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      # redirect_to [@commentable, { id: @commentable.id }], notice: t('controllers.common.notice_update', name: Comment.model_name.human)
      redirect_to @commentable, notice: t('controllers.common.notice_update', name: Comment.model_name.human)
    else
      redirect_to [:edit, @commentable, @comment], alert: "#{Comment.model_name.human}#{t 'errors.messages.blank'}"
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
    comment = Comment.find(params[:id])
    return if comment.user_id == current_user.id

    redirect_to root_url
  end
end
