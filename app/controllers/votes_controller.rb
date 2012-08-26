require 'csv'

class VotesController < ApplicationController
  def index
    @votes = Vote.all
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

    redirect_to session_url @session
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
