# This class contains all conference-specific settings

class Conference
  NAME = "XP Days"
  
  AVAILABLE_DURATION = [ "30 min", "75 min", "150 min" ]

  AVAILABLE_SESSION_TYPE = [ "hands on coding/design/architecture session", "discovery session", "experiential learning session", "short experience report (30 min)"]

  AVAILABLE_TOPICS_AND_NAMES = { "technology"=>"Technology and Technique",
    "customer"=>"Customer and Planning",
    "cases"=>"Intro's and Cases",
    "team"=>"Team and Individual",
    "process"=>"Process and Improvement",
    "other"=>"Other"}

  EMAIL_ADDRESS = "sessions@xpday.net"
  EMAIL_SUBJECT_PREFIX = "[Propile XP Days 2015] "
end