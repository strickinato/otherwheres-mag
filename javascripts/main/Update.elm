port module Update exposing (..)

import Array
import Issue exposing (DisplayImage(..), SpecificIssue(..))
import Model exposing (AnimationState, Model, Screen(..), initialAnimation, resetTime)
import Navigation
import Task
import Time exposing (Time, second)
import Util exposing ((=>))
import Window


type Msg
    = ExpandIssue SpecificIssue
    | HoverIssue SpecificIssue
    | ExpandImage DisplayImage
    | GoTo SpecificIssue
    | Viewport Window.Size
    | Tick Time
    | SetClosing Time
    | UrlChanged Navigation.Location
    | OpenGallery
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick clockTime ->
            (model
                |> advancePhraseAnimation clockTime
                |> advanceClosingAnimation clockTime
            )
                => Cmd.none

        SetClosing clockTime ->
            { model
                | closingAnimationState = Just { elapsedTime = 0, prevClockTime = clockTime }
                , closingAnimating = True
            }
                => Cmd.none

        ExpandImage display ->
            { model | displayImage = display } => Cmd.none

        ExpandIssue expandedIssue ->
            case expandedIssue of
                None ->
                    model => Task.perform SetClosing Time.now

                specificIssue ->
                    ( { model | expandedIssue = specificIssue }
                        |> resetPhrases
                    , Cmd.none
                    )

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

        UrlChanged location ->
            let
                commands =
                    [ Task.perform ExpandIssue (Task.succeed <| Issue.fromLocation location)
                    , case Issue.fromLocation location of
                        Featured ->
                            openGallery ()

                        _ ->
                            closeGallery ()
                    ]
            in
            ( { model | history = location :: model.history }
            , Cmd.batch commands
            )

        GoTo specificIssue ->
            {- This is simply used to change the URL, and ChangeUrl listens -}
            ( model, Navigation.newUrl <| Issue.slug specificIssue )

        OpenGallery ->
            ( model, openGallery () )

        NoOp ->
            model => Cmd.none


{-| We always want this to start with "Mostly True" because that's the best.
-}
resetPhrases : Model -> Model
resetPhrases model =
    { model
        | currentPhraseIndex = 0
        , phraseAnimationState = resetTime model.phraseAnimationState
    }


nextCurrentPhraseIndex : Model -> Int
nextCurrentPhraseIndex model =
    let
        length =
            Array.length model.phrases

        newCurrentPhraseIndex =
            model.currentPhraseIndex + 1
    in
    newCurrentPhraseIndex % length


advanceAnimation : Time -> Time -> AnimationState -> ( Bool, AnimationState )
advanceAnimation clockTime checkTime { elapsedTime, prevClockTime } =
    let
        newElapsedTime =
            elapsedTime + (clockTime - prevClockTime)
    in
    if newElapsedTime > checkTime then
        ( True, { prevClockTime = clockTime, elapsedTime = 0 } )
    else
        ( False, { prevClockTime = clockTime, elapsedTime = newElapsedTime } )


advancePhraseAnimation : Time -> Model -> Model
advancePhraseAnimation clockTime model =
    case advanceAnimation clockTime (second * 1.5) model.phraseAnimationState of
        ( True, newState ) ->
            { model
                | currentPhraseIndex = nextCurrentPhraseIndex model
                , phraseAnimationState = newState
            }

        ( False, newState ) ->
            { model | phraseAnimationState = newState }


advanceClosingAnimation : Time -> Model -> Model
advanceClosingAnimation time model =
    let
        updater thing =
            case thing of
                ( True, newState ) ->
                    { model
                        | expandedIssue = None
                        , displayImage = All
                        , closingAnimating = False
                        , closingAnimationState = Nothing
                    }

                ( False, newState ) ->
                    { model
                        | closingAnimating = True
                        , closingAnimationState = Just newState
                    }
    in
    model.closingAnimationState
        |> Maybe.map (advanceAnimation time (second / 2.0))
        |> Maybe.map updater
        |> Maybe.withDefault model


port openGallery : () -> Cmd msg


port closeGallery : () -> Cmd msg
