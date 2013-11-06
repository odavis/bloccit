class TopicsController < ApplicationController
  def index
  	@topics = Topic.paginate(page: params[:page], per_page: 10 )
  end

  def new
  	@topic = Topic.new
  	authorize! :create, @topic, message: "You need to be an admin to do that"
  end

  def show
  	@topic = Topic.find(params[:id])
    @posts = @topic.posts.paginate(page: params[:page], per_page: 10)
  end

  def edit
    @topic = Topic.find(params[:id])
    authorize! :update, @topic, message: "You need to be an admin."
  end

  def create
  	@topic = Topic.new(params[:topic])
    authorize! :create, @topic, message: "You need to be an admin."
  	if @topic.save
  		flash[:notice] = "Topic was saved successfully"
  		redirect_to @topic 
  		#redirect_to @topic, notice: "Topic was saved successfully"
  	else
  		flash[:error] = "Error creating topic. Please try again"
  		render :new 
  	end
  end

  def update
  	@topic = Topic.find(params[:id])
    authorize! :update, @topic, message: "You need to be an admin."
  	if @topic.update_attributes(params[:topic])
  		redirect_to @topic
  	else
  		flash[:error] = "Error updating topic. Please try again"
  		render :edit
  	end
  end

  def destroy
    @topic = Topic.find(params[:id])
    name = @topic.name

    authorize! :destory, @topic, message: "You need to own topic to delete."
    if @topic.destroy
      flash[:notice] = "#{name} was deleted successfully"
      redirect_to [@topic]
    else
      flash[:error] = "There was an error deleteing topic"
      render :show 
    end
  end
end
