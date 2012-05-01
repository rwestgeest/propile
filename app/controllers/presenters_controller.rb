class PresentersController < ApplicationController
  # GET /presenters
  # GET /presenters.json
  def index
    @presenters = Presenter.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @presenters }
    end
  end

  # GET /presenters/1
  # GET /presenters/1.json
  def show
    @presenter = Presenter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @presenter }
    end
  end

  # GET /presenters/new
  # GET /presenters/new.json
  def new
    @presenter = Presenter.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @presenter }
    end
  end

  # GET /presenters/1/edit
  def edit
    @presenter = Presenter.find(params[:id])
  end

  # POST /presenters
  # POST /presenters.json
  def create
    @presenter = Presenter.new(params[:presenter])

    respond_to do |format|
      if @presenter.save
        format.html { redirect_to @presenter, notice: 'Presenter was successfully created.' }
        format.json { render json: @presenter, status: :created, location: @presenter }
      else
        format.html { render action: "new" }
        format.json { render json: @presenter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /presenters/1
  # PUT /presenters/1.json
  def update
    @presenter = Presenter.find(params[:id])

    respond_to do |format|
      if @presenter.update_attributes(params[:presenter])
        format.html { redirect_to @presenter, notice: 'Presenter was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @presenter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /presenters/1
  # DELETE /presenters/1.json
  def destroy
    @presenter = Presenter.find(params[:id])
    @presenter.destroy

    respond_to do |format|
      format.html { redirect_to presenters_url }
      format.json { head :no_content }
    end
  end
end
