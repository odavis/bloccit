class CommentsController < ApplicationController
  
  def create
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:post_id])
    @comments = @post.comments

    @comment = current_user.comments.build(params[:comment])
    @comment.post = @post 

    authorize! :create, @comment, message: "You need to be signed in"
    if @comment.save
      flash[:notice] = "Comment was created"
      redirect_to [@topic, @post]
    else
      flash[:error] = "Comment was not saved. Pleease try again"
      render 'post/show'
    end
  end

  def destroy
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:post_id])

    @comment = @post.comments.find(params[:id])

    authorize! :destroy, @comment, message: "You need to own this comment to delete"
    if @comment.destroy
      flash[:notice] = "Comment deleted"
      redirect_to [@topic, @post]
    else
      flash[:error] = "There was an error deleting comment"
      redirect_to [@topic, @post]
    end
  end
end
