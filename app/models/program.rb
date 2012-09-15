class Program < ActiveRecord::Base
  attr_accessible :version
  attr_accessible :avgpaf
  has_many :program_entries

  def getProgramEntryMatrix # rows=slots, cols=tracks
    return unless @matrix.nil?
    @matrix = Hash.new
    program_entries.each do |pe|
      @matrix[[pe.slot, pe.track]] = pe
    end
    @matrix
  end

  def maxSlot
    return 0 unless !program_entries.nil? && !program_entries.empty?
    program_entries.collect{ |pe| pe.slot }.max
  end

  def maxTrack
    return 0 unless !program_entries.nil? && !program_entries.empty?
    program_entries.collect{ |pe| pe.track }.max
  end

  def eachSlot
    (1..maxSlot).each do |slot|
      yield(slot) 
    end
  end

  def eachTrack
    (1..maxTrack).each do |track|
      yield(track) 
    end
  end

  def entry(slot,track) 
    getProgramEntryMatrix 
    @matrix[[slot,track]]
  end

  def insertRow(beforeSlot)
    getProgramEntryMatrix
    eachSlot do |slot|
      if (slot>=beforeSlot) 
        eachTrack do |track|
          program_entry = entry(slot,track)
          if !program_entry.nil?
            program_entry.slot += 1
            program_entry.save
          end
        end
      end
    end
  end

  def calculatePaf
    self.avgpaf = calculateAvgPafForPresenters(Presenter.voting_presenters)
  end

  def calculateAvgPafForPresenters(presenters)
    return 0 unless presenters and not presenters.empty?
    pafPerPresenter = calculatePafForPresenters(presenters)
    pafPerPresenter.inject {|sum,x| sum+x}  / pafPerPresenter.size
  end

  def calculatePafForPresenters(presenters)
    pafPerPresenter = []
    presenters.each do |presenter|
      pafPerPresenter.append calculatePafForOnePresenter(presenter.votes)
    end 
    pafPerPresenter
  end

  def calculatePafForOnePresenter(votes_by_presenter)
    slotsForPresenter = Set.new
    votes_by_presenter.each do |vote| 
      if program_entries.exists? :session_id => vote.session.id
        slotsForPresenter << program_entries.where(:session_id => vote.session.id).first.slot
      end
    end
    slotsForPresenter.size
  end

end
