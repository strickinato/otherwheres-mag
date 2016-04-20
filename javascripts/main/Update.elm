module Update (..) where

import Effects exposing (Effects, tick)
import Model exposing (Model, Issue, initialAnimation, resetTime)
import Util exposing ((=>))
import Time exposing (Time, second)
import Array


type Action
  = ExpandIssue (Maybe Int)
  | HoverIssue (Maybe Int)
  | Tick Time
  | AnimateClosing Time
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
          if newElapsedTime > (1.5 * second) then
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

    AnimateClosing clockTime ->
      let
        newElapsedTime =
          case model.closingAnimationState of
            Nothing ->
              0

            Just { elapsedTime, prevClockTime } ->
              elapsedTime + (clockTime - prevClockTime)
      in
        if newElapsedTime > (second / 2.0) then
          { model
            | expandedIssueId = Nothing
            , closingAnimating = False
            , closingAnimationState = Nothing
          }
            => Effects.none
        else
          { model
            | closingAnimating = True
            , closingAnimationState =
                Just
                  { elapsedTime = newElapsedTime
                  , prevClockTime = clockTime
                  }
          }
            => Effects.tick AnimateClosing

    ExpandIssue maybeIssueId ->
      case maybeIssueId of
        Just id ->
          { model
            | expandedIssueId = maybeIssueId
            , currentPhraseIndex = 0
            , phraseAnimationState = resetTime model.phraseAnimationState
          } => Effects.none

        Nothing ->
          model => Effects.tick AnimateClosing

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
