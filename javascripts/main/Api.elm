import StartApp
import Html exposing (..)
import Task
import Effects exposing (Never)
import Json.Decode exposing (Value)

import Util exposing ((=>))

import Window
import Primer

import Model exposing (init, Model)
import Update exposing (update, Action(..))
import View exposing (view)

app : StartApp.App Model
app =
  StartApp.start
    { init = init => Effects.tick Tick
    , update = update openStripe.address
    , view = view
    , inputs = [ viewport ]
    }

main : Signal Html
main =
    app.html


port tasks : Signal (Task.Task Never ())
port tasks =
    app.tasks

openStripe : Signal.Mailbox ()
openStripe =
  Signal.mailbox ()

port requestOpenStripe : Signal ()
port requestOpenStripe =
  openStripe.signal
       
viewport : Signal Action
viewport =
  Signal.map Viewport (Primer.prime Window.dimensions)
