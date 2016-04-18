import StartApp
import Html exposing (..)
import Task
import Effects exposing (Never)
import Json.Decode exposing (Value)

import Util exposing ((=>))

import Model exposing (init, Model)
import Update exposing (update)
import View exposing (view)

app : StartApp.App Model
app =
    StartApp.start
        { init = init => Effects.none
        , update = update
        , view = view
        , inputs = []
        }

main : Signal Html
main =
    app.html


port tasks : Signal (Task.Task Never ())
port tasks =
    app.tasks
