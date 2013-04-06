require 'csv'

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
    topic = params[:topic]
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @program }
      format.pdf do 
        file_name = "tmp/program_#{@program.id}#{"_"+topic if !topic.nil?}.pdf"
        pdf = @program.generate_pdf(file_name, topic)
        send_file( file_name)
      end
    end
  end


  def program_board_cards
    @program = Program.find(params[:id])
    topic = params[:topic]
    respond_to do |format|
      format.pdf do 
        file_name = "tmp/program_cards_#{@program.id}#{"_"+topic if !topic.nil?}.pdf"
        pdf = @program.generate_program_board_cards_pdf(file_name, topic)
        send_file( file_name)
      end
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
  def create
    @program = Program.new(params[:program])
    @program.init_with_entries

    respond_to do |format|
      if @program.save
        format.html { redirect_to programs_url }
        format.json { head :no_content }
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
        format.html { redirect_to  :action => "edit" } 
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

  def calculate_paf
    @program = Program.find(params[:id])
    @program.calculatePaf

    respond_to do |format|
      if @program.save
        format.html { redirect_to  :action => "edit" } 
        format.json { render json: @program, status: :created, location: @program }
      else
        format.html { render action: "edit" }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  def csv 
    @program = Program.find(params[:id])
    program_csv = @program.generate_csv
    send_data(program_csv, :type => 'test/csv', :filename => "program_#{@program.id}.csv") 
  end

  def materials_csv
    @program = Program.find(params[:id])
    materials_csv = @program.generate_materials_csv
    send_data(materials_csv, :type => 'test/csv', :filename => "materials_#{@program.id}.csv") 
  end

  def insertSlot
    @program = Program.find(params[:id])
    logger.error "insertSlot id=#{params[:id]}, beforeSlot=#{params[:field][:before].to_i}"
    @program.insertSlot(params[:field][:before].to_i)

    respond_to do |format|
      if @program.save
        format.html { redirect_to  :action => "edit" } 
        format.json { render json: @program, status: :created, location: @program }
      else
        format.html { render action: "edit" }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  def removeSlot
    @program = Program.find(params[:id])
    @program.removeSlot(params[:field][:slot].to_i)

    respond_to do |format|
      if @program.save
        format.html { redirect_to  :action => "edit" } 
        format.json { render json: @program, status: :created, location: @program }
      else
        format.html { render action: "edit" }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end


  def insertTrack
    @program = Program.find(params[:id])
    @program.insertTrack(params[:field][:before].to_i)

    respond_to do |format|
      if @program.save
        format.html { redirect_to  :action => "edit" } 
        format.json { render json: @program, status: :created, location: @program }
      else
        format.html { render action: "edit" }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end


  def removeTrack
    @program = Program.find(params[:id])
    @program.removeTrack(params[:field][:track].to_i)

    respond_to do |format|
      if @program.save
        format.html { redirect_to  :action => "edit" } 
        format.json { render json: @program, status: :created, location: @program }
      else
        format.html { render action: "edit" }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  def activate
    @program = Program.find(params[:id])
    @program.activate
    @program.save

    respond_to do |format|
        format.html { redirect_to programs_url }
        format.json { head :no_content }
    end
  end

  def public
    @program = Program.activeProgram

    respond_to do |format|
      format.html { render :layout => 'public' } # public.html.erb
      format.json { render json: @program }
    end
  end

  def public_show
    @program = Program.find(params[:id])

    respond_to do |format|
      format.html { render :action => 'public', :layout => 'public' } # public.html.erb
      format.json { render json: @program }
    end
  end

end
