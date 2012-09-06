class ProgramsController < ApplicationController
  def index
    @programs = Program.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @programs }
    end
  end

  def show
    @program = Program.find(params[:id])
    @programMatrix = @program.getProgramEntryMatrix
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @program }
    end
  end

  def new
    @program = Program.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @program }
    end
  end

  def edit
    @program = Program.find(params[:id])

    respond_to do |format|
      format.html # edit.html.erb
      format.json { render json: @program }
    end
  end

  def copy
    from = Program.find(params[:id])
    to = from.dup
    to.version += " COPY"
    from.program_entries.each { |pe| to.program_entries.append(pe.dup) }
    to.save

    @program = to

    respond_to do |format|
      format.html # edit.html.erb
      format.json { render json: @program }
    end
  end

  def calculate_paf
    @program = Program.find(params[:id])
    @program.calculatePaf

    respond_to do |format|
      if @program.save
        format.html { redirect_to @program, notice: 'Program was successfully created.' }
        format.json { render json: @program, status: :created, location: @program }
      else
        format.html { render action: "new" }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @program = Program.new(params[:program])

    respond_to do |format|
      if @program.save
        8.times {|slot| 
          5.times {|track| 
            pe = ProgramEntry.new
            pe.slot=slot+1
            pe.track=track+1
            @program.program_entries<<pe
          }  
        }
        @program.save
        format.html { redirect_to @program, notice: 'Program was successfully created.' }
        format.json { render json: @program, status: :created, location: @program }
      else
        format.html { render action: "new" }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @program = Program.find(params[:id])

    respond_to do |format|
      if @program.update_attributes(params[:program])
        format.html { redirect_to @program, notice: 'Program was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @program = Program.find(params[:id])
    @program.destroy

    respond_to do |format|
      format.html { redirect_to programs_url }
      format.json { head :no_content }
    end
  end

end
