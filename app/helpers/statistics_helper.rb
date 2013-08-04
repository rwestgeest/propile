module StatisticsHelper

class BaseStatistics
  attr_reader :total_number_of_sessions, :total_number_of_presenters
  def initialize
    @total_number_of_sessions = Session.all.size
    @total_number_of_presenters = Presenter.all.size
  end
  def percentage(number, total_number)
    return percentage = (100 * number.to_f / total_number).to_i if total_number>0
    100
  end
end
def get_base_statistics
  BaseStatistics.new
end

class ReviewStatistics < BaseStatistics
  attr_reader :total_number_of_reviews, :total_number_of_reviewers, :number_of_sessions_reviewed, 
              :percentage_of_sessions_reviewed, :percentage_of_presenters_who_review, 
              :number_of_reviews_by_presenters

  def initialize
    super
    @total_number_of_reviews = Review.all.size
    @total_number_of_reviewers = Presenter.all.select {|p| !p.reviews.empty?}.size 
    @number_of_sessions_reviewed = Session.select {|s| !s.reviews.empty? }.size
    @percentage_of_sessions_reviewed = percentage(@number_of_sessions_reviewed, @total_number_of_sessions)
    @percentage_of_presenters_who_review = percentage(@total_number_of_reviewers, @total_number_of_presenters)
    @number_of_reviews_by_presenters = Presenter.all.group_by {|p| p.reviews.size}.sort
  end
end

def get_review_statistics
  ReviewStatistics.new
end

class SessionCompletenessStatistics < BaseStatistics
  attr_reader :with_short_description, :with_short_description_percentage,
              :with_outline_or_timetable, :with_outline_or_timetable_percentage,
              :updated_after_review, :updated_after_review_percentage,
              :complete, :complete_percentage

  def initialize
    super
    @with_short_description = Session.all.select {|s| !s.short_description.blank? }.size
    @with_short_description_percentage = percentage(@with_short_description, @total_number_of_sessions)
    @with_outline_or_timetable = Session.all.select {|s| !s.outline_or_timetable.blank? }.size
    @with_outline_or_timetable_percentage = percentage(@with_outline_or_timetable, @total_number_of_sessions)
    @updated_after_review = Session.all.select {|s| !s.has_new_review? }.size
    @updated_after_review_percentage = percentage(@updated_after_review, @total_number_of_sessions)
    @complete = Session.all.select {|s| s.complete? }.size
    @complete_percentage = percentage(@complete, @total_number_of_sessions)
  end
end

def get_session_completeness_statistics
  SessionCompletenessStatistics.new
end


class PresenterCompletenessStatistics < BaseStatistics
  attr_reader :with_name, :with_name_percentage,
              :with_bio, :with_bio_percentage

  def initialize
    super
    @with_name = Presenter.all.select {|p| p.name_filled_in? }.size
    @with_name_percentage = percentage(@with_name, @total_number_of_presenters)
    @with_bio = Presenter.all.select {|p| !p.bio.blank? }.size
    @with_bio_percentage = percentage(@with_bio, @total_number_of_presenters)
  end
end

def get_presenter_completeness_statistics
  PresenterCompletenessStatistics.new
end

end

