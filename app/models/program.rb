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
    #is voted session in program? -> paf is 1
    pafForPresenter = 0
    votes_by_presenter.each do |vote| 
      pafForPresenter += ( (program_entries.exists? :session_id => vote.session.id) ? 1 : 0 )
      #print "\n"
      #print "-- program_entries = ", program_entries
      #print "-- pafForPresenter = ", pafForPresenter
    end
    pafForPresenter
  end

end
