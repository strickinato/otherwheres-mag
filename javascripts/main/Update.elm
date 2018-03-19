module Update exposing (..)

import Array
import Model exposing (DisplayImage(..), Issue, Model, Screen(..), SpecificIssue(..), initialAnimation, resetTime)
import Time exposing (Time, second)
import Window
import Util exposing ((=>))
import Task


type Msg
    = ExpandIssue SpecificIssue
    | HoverIssue SpecificIssue
    | ExpandImage DisplayImage
    | Viewport Window.Size
    | Tick Time
    | AnimateClosing Time
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
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
            newModel => Cmd.none  --Effects.tick Tick

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
                    | expandedIssue = None
                    , displayImage = All
                    , closingAnimating = False
                    , closingAnimationState = Nothing
                }
                    => Cmd.none
            else
                { model
                    | closingAnimating = True
                    , closingAnimationState =
                        Just
                            { elapsedTime = newElapsedTime
                            , prevClockTime = clockTime
                            }
                }
                    => Task.perform AnimateClosing Time.now

        ExpandImage display ->
            { model | displayImage = display } => Cmd.none

        ExpandIssue expandedIssue ->
            case expandedIssue of
                None ->
                    model => Task.perform AnimateClosing Time.now

                specificIssue ->
                    { model
                        | expandedIssue = specificIssue
                        , currentPhraseIndex = 0
                        , phraseAnimationState = resetTime model.phraseAnimationState
                    }
                        => Cmd.none

        HoverIssue hoveredIssue ->
            { model | hoveredIssue = hoveredIssue } => Cmd.none

        Viewport { width, height } ->
            let
                screenType =
                    if width > 1250 then
                        Big
                    else if width > 1023 then
                        Medium
                    else
                        TooSmall
            in
            { model | screen = screenType }
                => Cmd.none

        NoOp ->
            model => Cmd.none


nextCurrentPhraseIndex : Model -> Int
nextCurrentPhraseIndex model =
    let
        length =
            Array.length model.phrases

        newCurrentPhraseIndex =
            model.currentPhraseIndex + 1
    in
    newCurrentPhraseIndex % length
