module Main exposing (..)

import AnimationFrame
import Html exposing (..)
import Json.Decode exposing (Value)
import Model exposing (Model, init)
import Navigation
import Time
import Update exposing (Msg(..), update)
import View exposing (view)
import Window


main : Program Never Model Msg
main =
    Navigation.program UrlChanged
        { init = \a -> ( init a, Cmd.none )
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
