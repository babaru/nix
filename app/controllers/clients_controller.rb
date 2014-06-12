class ClientsController < ApplicationController
	before_filter :has_login
	add_breadcrumb(I18n.t('model.list', model: Client.model_name.human), :clients_path, except: :index)

  # GET /clients
  # GET /clients.json
  def index
    add_breadcrumb(I18n.t('model.list', model: Client.model_name.human))

    @clients = Client.all()

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @clients }
    end
  end

  # GET /clients/new
  # GET /clients/new.json
  def new
    add_breadcrumb t('model.create', model: Client.model_name.human)
    @client = Client.new
    @client.created_by = current_user.id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @client }
    end
  end

  # GET /clients/1/edit
  def edit
    add_breadcrumb t('model.edit', model: Client.model_name.human)
    @client = Client.find(params[:id])
  end

  # POST /clients
  # POST /clients.json
  def create
  	new_file_name = upload_file(params[:client][:logo], "/public/files/logo_files/")
  	params[:client][:logo] = new_file_name
  	params[:client][:updated_by] = current_user.id
    @client = Client.new(params[:client])

    respond_to do |format|
      Client.transaction do
        if @client.save
          format.html { redirect_to clients_path, notice: 'Client was successfully created.' }
          format.json { render json: @client, status: :created, location: @client }
        else
          format.html { render action: "new" }
          format.json { render json: @client.errors, status: :unprocessable_entity }
        end
        # Medium.all.each do |medium|
        #   MediumPolicy.create!({
        #     medium_id: medium.id,
        #     client_id: @client.id,
        #     medium_discount: 1,
        #     company_discount: 1,
        #     medium_bonus_ratio: 0,
        #     company_bonus_ratio: 0
        #     }) unless MediumPolicy.exists?(client_id: @client.id, medium_id: medium.id)
        # end

      end
      # else
        # format.html { render action: "new" }
        # format.json { render json: @client.errors, status: :unprocessable_entity }
      # end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    @client = Client.find(params[:id])

    respond_to do |format|
    	if params[:client][:logo].blank?
    		params[:client][:logo] = @client.logo
    	else
    		new_file_name = upload_file(params[:client][:logo], "/public/files/logo_files/")
	    	FileUtils.rm Dir["#{Rails.root}/public/files/logo_files/"+@client.logo.to_s]
	    	params[:client][:logo] = new_file_name
    	end
	  	params[:client][:updated_by] = current_user.id
      @client.attributes = params[:client]
      if @client.save
        format.html { redirect_to clients_path, notice: 'Client was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client = Client.find(params[:id])
    Client.transaction do
      FileUtils.rm Dir["#{Rails.root}/public/files/logo_files/"+@client.logo.to_s]
      @client.destroy

      respond_to do |format|
        format.html { redirect_to clients_url, notice: 'Client was successfully deleted.' }
        format.json { head :no_content }
      end
    end
  end

  def assign_user
    @client = Client.find(params[:id])
    add_breadcrumb("#{@client.name} #{t('客户执行人员管理')}")
  end

  def save_client_users
    @client = Client.find(params[:id])
    if request.post?
      respond_to do |format|
        if @client.update_attributes(params[:client])
          format.html { redirect_to client_projects_path(@client), notice: "客户执行人员保存成功！" }
          format.json { head :no_content }
        else
          format.html { render action: "assigns" }
          format.json { render json: @client.errors, status: :unprocessable_entity }
        end
      end
    end
  end
end
