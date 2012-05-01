require 'spec_helper'

describe Presenter do
  describe 'sessions' do
    let(:presenter) { FactoryGirl.create :presenter }
    it "are empty by default" do
      presenter.sessions.should be_empty
    end
    it "can be added" do
      session = FactoryGirl.create(:session)
      presenter.sessions << session
      presenter.reload
      presenter.sessions.should include(session)
      session.presenters.should include(presenter)
    end
  end
end
