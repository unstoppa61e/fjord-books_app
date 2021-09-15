# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    comment = @commentable.comments.new comment_params
    comment.user_id = current_user.id
    comment.save
    name = Comment.model_name.human
    redirect_to @commentable, notice: t('controllers.common.notice_create', name: name)
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
