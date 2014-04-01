class DepartmentsController < ApplicationController

  def index
    @departments = initialize_grid(Department)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @departments }
    end
  end

  def new
    @department = Department.new()
    @permissions = Permission.all()
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @department }
    end
  end

  def edit
    @department = Department.find(params[:id])
    @permissions = Permission.all()
    @select_ids = @department.permissions.map{|p| p.id}
    respond_to do |format|
      format.html # edit.html.erb
      format.json { render json: @department }
    end
  end

  def create
    @department = Department.new(params[:department])

    respond_to do |format|
      if @department.save
        format.html { redirect_to departments_path(), notice: 'Department was successfully created.' }
        format.json { render json: @department, status: :created, location: @department }
      else
        format.html { render action: "new" }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  def update

    @department = Department.find(params[:id])

    respond_to do |format|
      if @department.update_attributes(params[:department])
        format.html { redirect_to departments_path(), notice: 'Department was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @department = Department.find(params[:id])
    @department.destroy

    respond_to do |format|
        format.html { redirect_to departments_path , notice: 'Department was successfully deleted.'}
        format.json { head :no_content }
    end
  end
end
