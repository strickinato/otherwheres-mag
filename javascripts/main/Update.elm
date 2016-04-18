module Update (..) where

import Effects exposing (Effects)
import Model exposing (Model, Issue)
import Util exposing ((=>))


type Action
  = ExpandIssue (Maybe Int)
  | NoOp


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    ExpandIssue maybeIssueId ->
      { model | expandedIssueId = maybeIssueId } => Effects.none

    NoOp ->
      model => Effects.none
