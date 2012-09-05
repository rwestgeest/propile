class Program < ActiveRecord::Base
  attr_accessible :version
  has_many :program_entries

  attr_accessor :pafPerPresenter 

  def calculatePaf
    calculatePafForAllPresenters(Presenter.all)
  end

  def calculatePafForAllPresenters(presenters)
    pafPerPresenter = []
    presenters.each do |presenter|
      pafPerPresenter.append calculatePafForPresenter(presenter.votes)
    end 
    pafPerPresenter
  end

  def calculatePafForPresenter(votes_by_presenter)
    slotsForPresenter = Set.new
    votes_by_presenter.each do |vote| 
      if program_entries.exists? :session_id => vote.session.id
        slotsForPresenter << program_entries.where(:session_id => vote.session.id).first.slot
      end
    end
    slotsForPresenter.size
  end

end
