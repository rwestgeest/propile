module StatisticsHelper

class ReviewStatistics
  attr_reader :total_number_of_sessions, :total_number_of_presenters, 
              :total_number_of_reviews, :total_number_of_reviewers, :number_of_sessions_reviewed, 
              :percentage_of_sessions_reviewed, :percentage_of_presenters_who_review, 
              :number_of_reviews_by_presenters

  def initialize
    @total_number_of_sessions = Session.all.size
    @total_number_of_presenters = Presenter.all.size
    @total_number_of_reviews = Review.all.size
    @total_number_of_reviewers = Presenter.all.select {|p| !p.reviews.empty?}.size 
    @number_of_sessions_reviewed = Session.select {|s| !s.reviews.empty? }.size
    @percentage_of_sessions_reviewed = 100
    @percentage_of_sessions_reviewed = (100 * @number_of_sessions_reviewed.to_f / @total_number_of_sessions).to_i if @total_number_of_sessions>0
    @percentage_of_presenters_who_review = 100
    @percentage_of_presenters_who_review = (100 * @total_number_of_reviewers.to_f / @total_number_of_presenters).to_i if @total_number_of_presenters>0
    @number_of_reviews_by_presenters = Presenter.all.group_by {|p| p.reviews.size}.sort
  end
end

def get_review_statistics
  ReviewStatistics.new
end

end

