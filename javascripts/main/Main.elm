module Main exposing (..)

import AnimationFrame
import Html exposing (..)
import Issue
import Json.Decode exposing (Value)
import Model exposing (Model)
import Navigation
import Time
import Update exposing (Msg(..), update)
import View exposing (view)
import Window


main : Program Never Model Msg
main =
    Navigation.program UrlChanged
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Window.resizes Viewport
        , AnimationFrame.times Tick
        ]


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( { issues = Issue.allIssues
      , expandedIssue = Issue.fromLocation location
      , hoveredIssue = Issue.None
      , phraseAnimationState = Model.initialAnimation
      , currentPhraseIndex = 0
      , phrases = Model.otherwheresPhrases
      , closingAnimating = False
      , closingAnimationState = Nothing
      , displayImage = Issue.All
      , history = [ location ]
      , screen = Model.Big
      }
    , case Issue.fromLocation location of
        Issue.Featured ->
            Update.openGallery ()

        _ ->
            Cmd.none
    )
