class ArchivedPresentersController < ApplicationController
  # GET /archived_presenters
  # GET /archived_presenters.json
  def index
    @archived_presenters = ArchivedPresenter.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @archived_presenters }
    end
  end

  # GET /archived_presenters/1
  # GET /archived_presenters/1.json
  def show
    @archived_presenter = ArchivedPresenter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @archived_presenter }
    end
  end

  # GET /archived_presenters/new
  # GET /archived_presenters/new.json
  def new
    @archived_presenter = ArchivedPresenter.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @archived_presenter }
    end
  end

  # GET /archived_presenters/1/edit
  def edit
    @archived_presenter = ArchivedPresenter.find(params[:id])
  end

  # POST /archived_presenters
  # POST /archived_presenters.json
  def create
    @archived_presenter = ArchivedPresenter.new(params[:archived_presenter])

    respond_to do |format|
      if @archived_presenter.save
        format.html { redirect_to @archived_presenter, notice: 'Archived presenter was successfully created.' }
        format.json { render json: @archived_presenter, status: :created, location: @archived_presenter }
      else
        format.html { render action: "new" }
        format.json { render json: @archived_presenter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /archived_presenters/1
  # PUT /archived_presenters/1.json
  def update
    @archived_presenter = ArchivedPresenter.find(params[:id])

    respond_to do |format|
      if @archived_presenter.update_attributes(params[:archived_presenter])
        format.html { redirect_to @archived_presenter, notice: 'Archived presenter was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @archived_presenter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /archived_presenters/1
  # DELETE /archived_presenters/1.json
  def destroy
    @archived_presenter = ArchivedPresenter.find(params[:id])
    @archived_presenter.destroy

    respond_to do |format|
      format.html { redirect_to archived_presenters_url }
      format.json { head :no_content }
    end
  end
end
