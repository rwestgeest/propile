class ProgramEntriesController < ApplicationController
  # GET /program_entries
  # GET /program_entries.json
  def index
    @program_entries = ProgramEntry.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @program_entries }
    end
  end

  # GET /program_entries/1
  # GET /program_entries/1.json
  def show
    @program_entry = ProgramEntry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @program_entry }
    end
  end

  # GET /program_entries/new
  # GET /program_entries/new.json
  def new
    @program_entry = ProgramEntry.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @program_entry }
    end
  end

  # GET /program_entries/1/edit
  def edit
    @program_entry = ProgramEntry.find(params[:id])
  end

  # POST /program_entries
  # POST /program_entries.json
  def create
    @program_entry = ProgramEntry.new(params[:program_entry])

    respond_to do |format|
      if @program_entry.save
        format.html { redirect_to @program_entry, notice: 'Program entry was successfully created.' }
        format.json { render json: @program_entry, status: :created, location: @program_entry }
      else
        format.html { render action: "new" }
        format.json { render json: @program_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /program_entries/1
  # PUT /program_entries/1.json
  def update
    @program_entry = ProgramEntry.find(params[:id])

    respond_to do |format|
      if @program_entry.update_attributes(params[:program_entry])
        format.html { redirect_to @program_entry, notice: 'Program entry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @program_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /program_entries/1
  # DELETE /program_entries/1.json
  def destroy
    @program_entry = ProgramEntry.find(params[:id])
    @program_entry.destroy

    respond_to do |format|
      format.html { redirect_to program_entries_url }
      format.json { head :no_content }
    end
  end
end
