module Model (..) where


type alias Model =
  { issues : List Issue
  , expandedIssueId : Maybe Int
  }


init : Model
init =
  { issues = allIssues
  , expandedIssueId = Nothing
  }


type alias Issue =
  { title : String
  , symbol : String
  , id : Int
  }


allIssues : List Issue
allIssues =
  [ volume1
  , volume2 2
  , volume2 3
  , volume2 4
  , volume2 5
  ]


volume1 : Issue
volume1 =
  { title = "Truth or Fiction"
  , symbol = "I"
  , id = 1
  }


volume2 : Int -> Issue
volume2 id =
  { title = "Travel"
  , symbol = "II"
  , id = id
  }
