class Program < ActiveRecord::Base
  attr_accessible :version
  attr_accessible :avgpaf
  has_many :program_entries, :autosave => true

  def programEntryMatrix # rows=slots, cols=tracks
    return @matrix unless @matrix.nil?
    @matrix = Hash.new
    program_entries.each { |pe| @matrix[[pe.slot, pe.track]] = pe }
    @matrix
  end

  def maxSlot
    program_entries.collect{ |pe| pe.slot }.max || 0 
  end

  def eachSlot
    (1..maxSlot).each { |slot| yield(slot) }
  end

  def maxTrack
    program_entries.collect{ |pe| pe.track }.max || 0
  end

  def eachTrack
    (1..maxTrack).each { |track| yield(track) }
  end

  def entry(slot,track) 
    programEntryMatrix() [[slot,track]]
  end

  def insertSlot(beforeSlot)
    (beforeSlot..maxSlot).each do |slot|
      eachTrack do |track|
        program_entry = entry(slot,track)
        if !program_entry.nil?
          program_entry.slot += 1
        end
      end
    end
    self
  end

  def insertTrack(beforeTrack)
    (beforeTrack..maxTrack).each do |track|
      eachSlot do |slot|
        program_entry = entry(slot,track)
        if !program_entry.nil?
          program_entry.track += 1
        end
      end
    end
    self
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
