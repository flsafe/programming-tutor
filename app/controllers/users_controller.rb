class UsersController < ApplicationController
  
  before_filter :require_user, :except=>[:new, :create]
  before_filter :require_admin, :except=>[:new, :create, :show_me]
  before_filter :destroy_anonymous, :only=>:create
  before_filter :require_beta_invite, :only=>[:create, :new]
  
  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  def show_me
    @user = User.find(current_user.id)
    
    respond_to do |format|
      format.html { render :action=>:show, :id=>current_user}
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @invite = BetaInvite.find_by_token session[:beta_invite]

    respond_to do |format|
      if @invite and @user.save
        redeem_beta_invite
        format.html { redirect_to :controller=>'overview' }
        #format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        #format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

  protected

  def require_beta_invite
    unless current_user and current_user.is_admin?
      redirect_to current_user_home unless session[:beta_invite]
    end
  end

  def redeem_beta_invite
    @invite.redeemed = 1
    @invite.save!
    session[:beta_invite] = nil 
  end
end
