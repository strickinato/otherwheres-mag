module Model (..) where

import Util exposing ((?==))
import Time exposing (Time)
import Array exposing (Array, fromList)
import Html exposing (..)


type alias Model =
  { issues : List Issue
  , expandedIssueId : Maybe Int
  , phraseAnimationState : AnimationState
  , currentPhraseIndex : Int
  , phrases : Array String
  }


type alias Issue =
  { id : Int
  , symbol : String
  , backgroundAsset : String
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
  [ Issue 1 "." "assets/menu/logo.png"
  , Issue 2 "IV" "assets/menu/volume_4.jpg"
  , Issue 3 "III" "assets/menu/volume_3.jpg"
  , Issue 4 "II" "assets/menu/volume_2.jpg"
  , Issue 5 "I" "assets/menu/volume_1.jpg"
  ]


findSelectedIssue : Model -> Maybe Issue
findSelectedIssue model =
  model.issues
    |> List.filter (\issue -> issue.id ?== model.expandedIssueId)
    |> List.head


volume2 : Int -> String -> Issue
volume2 id color =
  { id = id
  , symbol = "II"
  , backgroundAsset = color
  }


isShowingMenu : Model -> Bool
isShowingMenu model =
  case model.expandedIssueId of
    Just _ ->
      False

    Nothing ->
      True
