module Model (..) where

import Util exposing ((?==))
import Time exposing (Time)
import Array exposing (Array, fromList)


type alias Model =
  { issues : List Issue
  , expandedIssueId : Maybe Int
  , phraseAnimationState : AnimationState
  , currentPhraseIndex : Int
  , phrases : Array String
  }


init : Model
init =
  { issues = allIssues
  , expandedIssueId = Nothing
  , phraseAnimationState = initialAnimation
  , currentPhraseIndex = 0
  , phrases = otherwheresPhrases
  }


type alias AnimationState =
  { prevClockTime : Time
  , elapsedTime : Time
  }

initialAnimation =
  { prevClockTime = 0.0
  , elapsedTime = 0.0
  }

type alias Issue =
  { title : String
  , symbol : String
  , id : Int
  , backgroundColor : String
  }


otherwheresPhrases : Array String
otherwheresPhrases =
  fromList
    [ "artsy fartsy"
    , "ready to pop"
    ]


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
