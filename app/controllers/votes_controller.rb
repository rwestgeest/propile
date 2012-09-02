require 'csv'

class VotesController < ApplicationController
  def index
    @votes = Vote.all
    @sessions = Session.all.find_all { |s| s.votes.size>0 }.sort { 
      |s1, s2| 
      size_compare = (s1.votes.size <=> s2.votes.size) 
      size_compare==0 ? (s1.created_at <=> s2.created_at) : size_compare
    }.reverse
  end

  def show
    @vote = Vote.find(params[:id])
  end

  def new
    @session = Session.find(params[:session_id])
    @vote =  @session.votes.build()
    @vote.presenter = current_presenter
  end

  def edit
    @vote = Vote.find(params[:id])
  end

  def create
    @session = Session.find(params[:session_id])
    @vote =  @session.votes.build()
    @vote.presenter = current_presenter

    if @vote.save
      redirect_to session_url @session
    else
      render action: "new"
    end
  end

  def update
    @vote = Vote.find(params[:id])

    if @vote.update_attributes(params[:vote])
      redirect_to @vote, notice: 'Vote was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @vote = Vote.find(params[:id])
    @session = @vote.session
    @vote.destroy

    redirect_to(:back)
  end

  def csv 
    @votes = Vote.all
    vote_csv = CSV.generate(options = { :col_sep => ';' }) do |csv| 
      #header row
      csv << [ "Title", "Subtitle",
               "Presenters", 
               "Voter" ]
      #data row
      @votes.each do |vote| 
        csv << [ vote.session.title, vote.session.sub_title, 
                 vote.session.presenter_names, 
                 vote.presenter.name
               ]
      end
    end
    send_data(vote_csv, :type => 'test/csv', :filename => 'votes.csv') 
  end

  def csv_paf_sessions
    @votes = Vote.all
    vote_csv_paf_sessions = CSV.generate(options = { :col_sep => ';' }) do |csv| 
      #header row
      csv << [ "Session id", "Title", 
               "Presenter 1", "Presenter 2", 
               "Length", "Topic" ]
      #data row
      @votes.each do |vote| 
        csv << [ vote.session.id, vote.session.title, 
                 vote.session.first_presenter.name, (vote.session.second_presenter.nil? ? nil : vote.session.second_presenter.name), 
                 vote.session.duration, vote.session.topic
               ]
      end
    end
    send_data(vote_csv_paf_sessions, :type => 'test/csv', :filename => 'votes_paf_sessions.csv') 
  end


  def csv_paf_presenters
    @votes = Vote.all
    vote_csv_paf_presenters = CSV.generate(options = { :col_sep => ';' }) do |csv| 
      #header row
      csv << [ "Voter", 
               "Session id"
             ]
      #data row
      @votes.each do |vote| 
        csv << [ vote.presenter.name,
                 vote.session.id, 
               ]
      end
    end
    send_data(vote_csv_paf_presenters, :type => 'test/csv', :filename => 'votes_paf_presenters.csv') 
  end

end
