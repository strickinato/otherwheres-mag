module Model (..) where

import Util exposing ((?==))
import Time exposing (Time)
import Array exposing (Array, fromList)
import Html exposing (..)


type alias Model =
  { issues : List Issue
  , expandedIssueId : Maybe Int
  , hoveredIssueId : Maybe Int
  , phraseAnimationState : AnimationState
  , currentPhraseIndex : Int
  , phrases : Array String
  }


type alias Issue =
  { id : Int
  , symbol : String
  , class : String
  , title : String
  }


init : Model
init =
  { issues = allIssues
  , expandedIssueId = Nothing
  , hoveredIssueId = Nothing
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


otherwheresPhrases : Array String
otherwheresPhrases =
  fromList
    [ "artsy fartsy"
    , "ready to pop"
    , "Toby's worst nightmare"
    , "an OK zine"
    ]


currentPhrase : Model -> String
currentPhrase model =
  Maybe.withDefault "" (Array.get model.currentPhraseIndex model.phrases)


allIssues : List Issue
allIssues =
  [ Issue 2 "IV" "volume4" "Disasters"
  , Issue 3 "III" "volume3" "Comics"
  , Issue 4 "II" "volume2" "Travel"
  , Issue 5 "I" "volume1" "Truth or Fiction"
  ]


findSelectedIssue : Model -> Maybe Issue
findSelectedIssue model =
  model.issues
    |> List.filter (\issue -> issue.id ?== model.expandedIssueId)
    |> List.head


isShowingMenu : Model -> Bool
isShowingMenu model =
  case model.expandedIssueId of
    Just _ ->
      False

    Nothing ->
      True
