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
    @session = @vote.session
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

end
