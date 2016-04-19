module Model (..) where

import Util exposing ((?==))

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
  , backgroundColor : String
  }


allIssues : List Issue
allIssues =
  [ volume1
  , volume2 2 "green"
  , volume2 3 "yellow"
  , volume2 4 "orange"
  , volume2 5 "black"
  ]


findSelectedIssue : Model -> Maybe Issue
findSelectedIssue model =
  model.issues
    |> List.filter (\issue -> issue.id ?== model.expandedIssueId)
    |> List.head


volume1 : Issue
volume1 =
  { title = "Truth or Fiction"
  , symbol = "I"
  , id = 1
  , backgroundColor = "red"
  }


volume2 : Int -> String -> Issue
volume2 id color =
  { title = "Travel"
  , symbol = "II"
  , id = id
  , backgroundColor = color
  }



isShowingMenu : Model -> Bool
isShowingMenu model =
  case model.expandedIssueId of
    Just _ ->
      False

    Nothing ->
      True
