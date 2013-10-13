# 0.4.36
# 0.4.35
# 0.4.34
# 0.4.33
# 0.4.32
# 0.4.31
# 0.4.30
# 0.4.29
  Improve dashboard and statistics
# 0.4.28
  Improve dashboard and statistics
# 0.4.27
  Improve dashboard
# 0.4.26
  Fixed bug #32
# 0.4.25
  Improve dashboard
# 0.4.24
  Improve dashboard
# 0.4.23
  Improve dashboard
# 0.4.22
  session review preview forgets the action on the session
# 0.4.21
  Review Preview
  modifications since last login 
  clarify 2-step submission process
# 0.4.20 
  improve layout of reviews
  improve session feedback emails
  Follow all updates to a session with RSS 
# 0.4.19 
  "nog authorized" bug
# 0.4.18 
  remove all public + pgm activation stuff (after Pascal's new export functionality)
  re-use activation col as exported_at
  restrictions on session fields (laptops_required, topic)
  start new conference
  restrictions on session fields (duration, max_participants)
  everything we need to open call-for-sessions: logo, duration,
session_types, add new presenters
# 0.4.17 
  public presenter page: add list of sessions for this presenter
# 0.4.16 
  improvements to program page
  print session desc per topic
  add extract_public_program script
  session id on card and desc 
  simplify feedback form on back side of the session cards
  wikinize: display link with name; more possiblities for links
  program edit: collapsible divs
# 0.4.15
  same as 0.4.14 but deploy failed
# 0.4.14
  try to extract public program files 
  bug fix: can't remove 2nd presenter, not even as maintainer 
  maintainer should be able to define maintainer role for someone
# 0.4.13
  printable cards and descriptions for the wall for sessions (pdf)  -> improvements
# 0.4.12
  printable cards and descriptions for the wall for sessions (pdf)  -> improvements
# 0.4.11
  printable cards and descriptions for the wall for sessions (pdf) 
# 0.4.10
  maintainer can change email of presenter
  some small improvements: all about views and readability and usability
# 0.4.9 
  make a get_prod_db_to_test in Rakefile 
  public program page: include legend for colors
  bug: program destroy: should also destroy associated program entries 
  mark program as "current" in config 
  public program-matrix with public bios 
  public program-matrix with public session descriptions 

# 0.4.8 
  maintainers can edit sessions + presenters of a session 
  minor bugs in public pgm page

# 0.4.7 
  Public Program matrix 

# 0.4.6
* minor bug fixes in Program show and edit 

# 0.4.5
* insertRow and insertColumn 
* difference between Program show and edit 

# 0.4.4
* Fix release problems (stylesheet)

# 0.4.3
* generate csv with sessions that are selected in PGM
* show program: some improvements

# 0.4.2 
* Paf uses only voting presenters

# 0.4.0
* PGM meeting: generate input for Pascal's magical Pgm composer tool
* Comments4 PGM meeting: generate cards to use during program comittee meeting 
* calculate paf for programs

# 0.3.1

* sorteervolgorde van presenter lijst aanpassen 
* presenter-activity dashboard: lijstje/dashboard op presenter pagina met de sessies waar hij iets mee gedaan heeft (sessie/review/comment) 
* bug fixes and small improvements 
* voting: switch on/off (as a maintainer) 
* vote for a session 
* revoke vote 
* Excel dump van alle sessies 
* see all votes 
* deploy in PR (en move the stories van "deployed on test" naar "deployed in PR) (en maak tag) 

# 0.3.0

* first version of voting
* tag maken voor gereleasede versie 
* Bug: show sessions contains the paragraph "SHORT" 2x 
* fix holapola bug 
* I want to see the sessions grouped by topic (or at least see the topic in the list). 
* sortable columns in session list 
* clickable names for reviewers/commenters in show-session 
* deploy in PR (en move the stories van "deployed on test" naar "deployed in PR) (en maak tag) 

# 0.2.2
Fixes

* remove wiewie
* find or create presenter case ignored
* login email case ignored

# 0.2.1

Fixes

* tag for released version
* fix IE9
* mail notification on comment creation

# 0.2.0

Small improvements on initial release

* split up new session in basic fields and other details (after login)
* show number of reviews for a session in the session overview list
* captcha for session submit because of spam
* layout van de sessie pagina -- breedte van de body vastleggen
* add some editor to the text-area's so that users can do basic formatting 
* opkuisen van ongeldige presenters in reviews/comments omdat dat nu niet meer kan

# 0.1.0

Initial release with essential features:

* submitting sessions
* info on process
* managing sessions reviews and comments on reviews
* managing presenters profiles
* authorisation 
** presenters can edit their own stuff 
** maintainers can all presenters
* authentication
* some text formatting on short description and description fields in
  session and text fields in reviews and comments

