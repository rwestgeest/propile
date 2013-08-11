class ProgramEntriesController < ApplicationController
  def index
    @program_entries = ProgramEntry.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @program_entries }
    end
  end

  def show
    @program_entry = ProgramEntry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @program_entry }
    end
  end

  def new
    @program = Program.find(params[:program_id])
    @program_entry =  @program.program_entries.build()
    @program_entry.slot = params[:slot]
    @program_entry.track = params[:track]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @program_entry }
    end
  end

  def edit
    @program_entry = ProgramEntry.find(params[:id])
    respond_to do |format|
      format.html # edit.html.erb
      format.json { render json: @program_entry }
      format.js 
    end
  end

  def create
    @program_entry = ProgramEntry.new(params[:program_entry])

    respond_to do |format|
      if @program_entry.save
        format.html { redirect_to  :controller => 'programs', :action => 'edit', :id =>  @program_entry.program.id  }
        format.json { render json: @program_entry, status: :created, location: @program_entry }
      else
        format.html { render action: "new" }
        format.json { render json: @program_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @program_entry = ProgramEntry.find(params[:id])

    respond_to do |format|
      if @program_entry.update_attributes(params[:program_entry])
        format.html { redirect_to  :controller => 'programs', :action => 'edit', :id =>  @program_entry.program.id  }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @program_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @program_entry = ProgramEntry.find(params[:id])
    @program = @program_entry.program
    @program_entry.destroy

    respond_to do |format|
      format.html { redirect_to program_entries_url }
      format.json { head :no_content }
    end
  end
end
