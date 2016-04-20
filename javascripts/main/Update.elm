module Update (..) where

import Effects exposing (Effects, tick)
import Model exposing (Model, Issue, initialAnimation)
import Util exposing ((=>))
import Time exposing (Time, second)
import Array


type Action
  = ExpandIssue (Maybe Int)
  | HoverIssue (Maybe Int)
  | Tick Time
  | NoOp


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    Tick clockTime ->
      let
        { elapsedTime, prevClockTime } =
          model.phraseAnimationState

        newElapsedTime =
          elapsedTime + (clockTime - prevClockTime)

        newModel =
          if newElapsedTime > second then
            { model
              | currentPhraseIndex = nextCurrentPhraseIndex model
              , phraseAnimationState =
                  { elapsedTime = 0
                  , prevClockTime = clockTime
                  }
            }
          else
            { model
              | phraseAnimationState =
                  { elapsedTime = newElapsedTime
                  , prevClockTime = clockTime
                  }
            }
      in
        newModel => Effects.tick Tick

    ExpandIssue maybeIssueId ->
      { model | expandedIssueId = maybeIssueId } => Effects.none

    HoverIssue maybeIssueId ->
      { model | hoveredIssueId = maybeIssueId } => Effects.none

    NoOp ->
      model => Effects.none


nextCurrentPhraseIndex : Model -> Int
nextCurrentPhraseIndex model =
  let
    length =
      Array.length model.phrases

    newCurrentPhraseIndex =
      model.currentPhraseIndex + 1
  in
    newCurrentPhraseIndex % length
