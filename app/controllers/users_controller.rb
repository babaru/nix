class UsersController < ApplicationController
  before_filter :has_login
  # GET /users
  # GET /users.json
  def index
   @users_grid = initialize_grid(User)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users_grid }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
   
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path(), notice: '用户已成功创建.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    @user = User.find(params[:id])

    respond_to do |format|
      @user.update_attributes(params[:user])
      if @user.update_attributes(params[:user])
        format.html { redirect_to users_path(), notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      if params[:id].to_i != current_user.id
        format.html { redirect_to users_url , notice: 'User was successfully deleted.'}
        format.json { head :no_content }
      else
        format.html { redirect_to users_url, alert: 'This user is sign_in.' }
        format.json { head :no_content }
      end
    end
  end
end
