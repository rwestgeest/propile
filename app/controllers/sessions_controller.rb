require 'csv'

class SessionsController < ApplicationController
  skip_before_filter :authorize_action, :only => [:create, :thanks, :csv,:rss,:activity_rss]
  helper_method :sort_column, :sort_direction

  COMPLETE_SESSION_INCLUDES = {:reviews => [{:comments => {:presenter => :account}}, {:presenter => :account}]},{:first_presenter => :account},{:second_presenter => :account}
  
  def index
    eager_loaded = [:reviews ,{:first_presenter => :account},{:second_presenter => :account}]
    if sort_column=="reviewcount"
      @sessions = Session.includes(eager_loaded).all.sort {
        |s1, s2| 
        size_compare = (s1.reviews.size <=> s2.reviews.size) 
        size_compare==0 ? (s1.created_at <=> s2.created_at) : size_compare
      } 
      @sessions = sort_direction=="asc" ? @sessions :  @sessions.reverse 
    elsif sort_column=="presenters"
      @sessions = Session.includes(eager_loaded).all.sort_by { |s| s.presenter_names.upcase }
      @sessions = sort_direction=="asc" ? @sessions :  @sessions.reverse 
    elsif sort_column=="voted"
      @sessions = Session.includes(eager_loaded).all.sort {
        |s1, s2| 
        size_compare =  ( (s1.presenter_has_voted_for? current_presenter.id).to_s <=> (s2.presenter_has_voted_for? current_presenter.id).to_s )
        size_compare==0 ? (s1.created_at <=> s2.created_at) : size_compare
      } 
      @sessions = sort_direction=="asc" ? @sessions :  @sessions.reverse 
    else
      @sessions = Session.includes(eager_loaded).order( "upper("+sort_column+") " + sort_direction).all
    end
    @voting_active = PropileConfig.voting_active?
    @maintainer = current_account.maintainer?
    @presenter = current_account.presenter
    @previous_login_time = previous_login_time
    @active_sessions = @sessions.select {|session| session.state != Session::CANCELED }
    @canceled_sessions = @sessions.select {|session| session.state == Session::CANCELED }
  end

  def show
    @session = Session.find(params[:id])
    @current_presenter_has_voted_for_this_session = Vote.presenter_has_voted_for?(current_presenter.id, params[:id]) 
    @my_vote = Vote.vote_of_presenter_for(current_presenter.id, params[:id]) 
    
    respond_to do |format|
      format.html { render }
      format.json { render json: @session }
      format.pdf do 
        file_name = "tmp/session_#{@session.id}.pdf"
        pdf = @session.generate_pdf(file_name)
        send_file( file_name)
      end
    end
  end

  def program_board_card
    @session = Session.find(params[:id])
    
    respond_to do |format|
      format.pdf do 
        file_name = "tmp/session_card_#{@session.id}.pdf"
        pdf = @session.generate_program_board_card_pdf(file_name)
        send_file( file_name)
      end
    end
  end

  def pcm_cards
    respond_to do |format|
      format.pdf do 
        file_name = "tmp/pcm_cards.pdf"
        pdf = Session.generate_program_committee_cards_pdf(file_name)
        send_file( file_name)
      end
    end
  end

  def new
    #if !PropileConfig.submit_session_active? then raise "Session submission is closed" end
    @session = Session.new
  end

  def edit
    @session = Session.find(params[:id])
  end

  def thanks
    @session = Session.find(params[:id])
  end

  def csv 
    @sessions = Session.all
    session_csv = CSV.generate(options = { :col_sep => ';' }) do |csv| 
      #header row
      csv << [ "Title", "Subtitle",
        "Presenters", "Created", "Modified",
        "Type", "Topic", "Duration",
        "Reviews",
        "Goal",
        "Intended Audience", "Experience Level",
        "Max participants", "Laptops", "Other limitations", "Room setup", "Materials",
        "Short" ]
      #data row
      @sessions.each do |session| 
        csv << [ session.title, session.sub_title, 
          session.presenter_names, session.created_at, session.updated_at,
          session.session_type, session.topic_name, session.duration,
          session.reviews.size,
          session.session_goal,
          session.intended_audience, session.experience_level,
          session.max_participants, session.laptops_required, session.other_limitations, session.room_setup, session.materials_needed,
          session.short_description
        ].collect {|field| (field.blank?) ?  "(none)" : field }
      end
    end
    send_data(session_csv, :type => 'test/csv', :filename => 'sessions.csv') 
  end

  def create
    @session = Session.new(params[:session])
    unless Captcha.verified?(self)
      flash[:alert]  = I18n.t('sessions.captcha_error')
      render :action => 'new'
      return
    end
    if @session.save
      redirect_to thanks_session_path(@session), notice: 'Session was successfully created.' 
      @session.presenters.each { |presenter| Postman.deliver(:session_submit, presenter, @session) }
    else
      render action: "new"
    end
  end

  def update
    @session = Session.find(params[:id])

    if @session.update_attributes(params[:session])
      redirect_to @session, notice: 'Session was successfully updated.' 
    else
      render action: "edit" 
    end
  end

  def destroy
    @session = Session.find(params[:id])
    @session.destroy

    redirect_to sessions_url 
  end

  def rss
    account = nil
    authenticate_with_http_basic do |username,password|
      account = Account.authenticate_by_email_and_password(username,password)
    end
    if account.nil? then
      request_http_basic_authentication("Propile RSS feeds")
    else
      
      @this_session = Session.includes(COMPLETE_SESSION_INCLUDES).find(params[:id])
      @last_update = @this_session.updated_at
      @this_session.reviews.each do |review|
        @last_update = [@last_update,review.updated_at].max
        review.comments.each do |comment|
          @last_update = [ @last_update,comment.updated_at ].max
        end
      end
    end
  end

  def activity_rss
    account = nil
    authenticate_with_http_basic do |username,password|
      account = Account.authenticate_by_email_and_password(username,password)
    end
    if account.nil? then
      request_http_basic_authentication("Propile RSS feeds")
    else
      @sessions = Session.includes(COMPLETE_SESSION_INCLUDES).limit(200)
      @last_update = Time.now
      @sessions.each do |session|
        @last_update = session.updated_at
        session.reviews.each do |review|
          @last_update = [@last_update,review.updated_at].max
          review.comments.each do |comment|
            @last_update = [ @last_update,comment.updated_at ].max
          end
        end
      end
    end
  end


  def sort_column
    params[:sort] ? params[:sort] : "reviewcount"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
