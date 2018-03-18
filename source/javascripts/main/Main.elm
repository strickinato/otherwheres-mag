module Main exposing (..)

import AnimationFrame
import Html exposing (..)
import Json.Decode exposing (Value)
import Model exposing (Model, init)
import Update exposing (Msg(..), update)
import Time
import View exposing (view)
import Window


main : Program Never Model Msg
main =
    Html.program
        { init = ( init, Cmd.none )
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
