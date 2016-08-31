require 'rubygems'
require 'thor'
module ThorScripts
  class Sessions < Thor
    desc "export_accepted", "export accepted sesisons"
    def export_accepted
      puts ProgramEntry.all.map {|e| e.session }.compact.uniq.map {|s| session_line(s)}.join("\n")
    end
    desc "export_declined", "export declined sesisons"
    def export_declined
      puts (Session.all.select{|s| !s.canceled? } - ProgramEntry.all.map {|e| e.session }.compact.uniq).map {|s| session_line(s)}.join("\n")
    end

    private
    def session_line(s)
      [ s.title, name_of(s.first_presenter), email_of(s.first_presenter), name_of(s.second_presenter), email_of(s.second_presenter) ].compact.map{|c| quote(c) }. join("; ")
    end
    def quote(c)
      "'#{c}'"
    end
    def name_of presenter
      return nil if presenter.nil?
      presenter.name
    end
    def email_of presenter
      return nil if presenter.nil?
      presenter.email
    end
  end
end
