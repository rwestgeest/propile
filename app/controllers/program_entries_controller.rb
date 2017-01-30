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
      format.js 
    end
  end

  def edit
    @program_entry = ProgramEntry.find(params[:id])
    @program=@program_entry.program
    respond_to do |format|
      format.html # edit.html.erb
      format.json { render json: @program_entry }
      format.js 
    end
  end

    def confirm
    @program_entry = ProgramEntry.find(params[:id])
    @program=@program_entry.program
    respond_to do |format|
      format.html # edit.html.erb
      format.json { render json: @program_entry }
      format.js
    end
  end

  def edit_location
    @program_entry = ProgramEntry.find(params[:id])
    @program=@program_entry.program
    respond_to do |format|
      format.html # edit.html.erb
      format.json { render json: @program_entry }
      format.js 
    end
  end

  def create
    @program_entry = ProgramEntry.new(params[:program_entry])
    @program=@program_entry.program

    respond_to do |format|
      if @program_entry.save
        format.html { redirect_to  :controller => 'programs', :action => 'edit', :id =>  @program_entry.program.id  }
        format.json { render json: @program_entry, status: :created, location: @program_entry }
        format.js 
      else
        format.html { render action: "new" }
        format.json { render json: @program_entry.errors, status: :unprocessable_entity }
        format.js 
      end
    end
  end

  def update
    @program_entry = ProgramEntry.find(params[:id])
    @program=@program_entry.program

    respond_to do |format|
      if @program_entry.update_attributes(params[:program_entry])
        format.html { redirect_to  :controller => 'programs', :action => 'edit', :id =>  @program_entry.program.id  }
        format.json { render json: @program_entry, status: :updated, location: @program_entry }
        format.js 
      else
        format.html { render action: "edit" }
        format.json { render json: @program_entry.errors, status: :unprocessable_entity }
        format.js 
      end
    end
  end

  def update_location
    @program_entry = ProgramEntry.find(params[:id])
    old_slot = @program_entry.slot
    old_track = @program_entry.track
    new_slot = params[:program_entry][:slot].to_i
    new_track = params[:program_entry][:track].to_i

    @program=Program.find(@program_entry.program.id)
    respond_to do |format|
      if @program.switch_entries(old_slot, old_track, new_slot, new_track)
        @program_entry.reload
        format.html { redirect_to  :controller => 'programs', :action => 'edit', :id =>  @program_entry.program.id  }
        format.json { render json: @program_entry, status: :updated, location: @program_entry }
        format.js 
      else
        format.html { render action: "edit" }
        format.json { render json: @program_entry.errors, status: :unprocessable_entity }
        format.js 
      end
    end
  end

end
