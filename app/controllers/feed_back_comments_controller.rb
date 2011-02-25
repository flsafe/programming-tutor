class FeedBackCommentsController < ApplicationController
  before_filter :require_admin, :only=>[:index, :show, :edit, :update, :destroy]

  # GET /feed_back_comments
  # GET /feed_back_comments.xml
  def index
    @feed_back_comments = FeedBackComment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @feed_back_comments }
    end
  end

  # GET /feed_back_comments/1
  # GET /feed_back_comments/1.xml
  def show
    @feed_back_comment = FeedBackComment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @feed_back_comment }
    end
  end

  # GET /feed_back_comments/new
  # GET /feed_back_comments/new.xml
  def new
    @feed_back_comment = FeedBackComment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @feed_back_comment }
    end
  end

  # GET /feed_back_comments/1/edit
  def edit
    @feed_back_comment = FeedBackComment.find(params[:id])
  end

  # POST /feed_back_comments
  # POST /feed_back_comments.xml
  def create
    @feed_back_comment = FeedBackComment.new(params[:feed_back_comment])
    @feed_back_comment.save
    render :text=>"Got it"
  end

  # PUT /feed_back_comments/1
  # PUT /feed_back_comments/1.xml
  def update
    @feed_back_comment = FeedBackComment.find(params[:id])

    respond_to do |format|
      if @feed_back_comment.update_attributes(params[:feed_back_comment])
        flash[:notice] = 'FeedBackComment was successfully updated.'
        format.html { redirect_to(@feed_back_comment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @feed_back_comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /feed_back_comments/1
  # DELETE /feed_back_comments/1.xml
  def destroy
    @feed_back_comment = FeedBackComment.find(params[:id])
    @feed_back_comment.destroy

    respond_to do |format|
      format.html { redirect_to(feed_back_comments_url) }
      format.xml  { head :ok }
    end
  end
end
