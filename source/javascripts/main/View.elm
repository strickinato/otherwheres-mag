module View (..) where

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Model exposing (Model, Issue)
import Update exposing (Action(..))
import Signal


view : Signal.Address Action -> Model -> Html
view address model =
  let
    styles =
      style
        [ ( "width", "100%" )
        , ( "height", "100%" )
     --   , ( "display", "flex" )
     --   , ( "flex-direction", "row" )
     --   , ( "align-items", "stretch" )
        ]
  in
    div
      [ id "wrapper", styles ]
      (viewContent address model)


viewContent : Signal.Address Action -> Model -> List Html
viewContent address model =
  viewIssueMenu address model


viewSingleIssue : Signal.Address Action -> Issue -> List Html
viewSingleIssue address issue =
  [ viewSingleIssueSidebar address issue
  , viewSingleIssueContent address issue
  ]


viewSingleIssueContent : Signal.Address Action -> Issue -> Html
viewSingleIssueContent address issue =
  let
    styles =
      style
        [ ( "background-color", "red" )
        , ( "flex", "0 0 80%" )
        ]
  in
    div
      [ styles ]
      [ text issue.title ]


viewSingleIssueSidebar : Signal.Address Action -> Issue -> Html
viewSingleIssueSidebar address issue =
  let
    styles =
      style
        [ ( "background-color", "green" )
        , ( "flex", "0 0 20%" )
        ]

    expandHandler =
      Nothing
        |> ExpandIssue
        |> onClick address
  in
    div
      [ styles, expandHandler, class "issue sidebar" ]
      [ text issue.symbol ]


viewIssueMenu : Signal.Address Action -> Model -> List Html
viewIssueMenu address model =
  (List.map (renderIssueMenuItem address model.expandedIssueId) model.issues)


renderIssueMenuItem : Signal.Address Action -> Maybe Int -> Issue -> Html
renderIssueMenuItem address maybeExpandedId issue =
  let
    isMenu =
      case maybeExpandedId of
        Just _ -> False
        Nothing -> True

    isExpanded =
      (Maybe.withDefault 0 maybeExpandedId) == issue.id

    visibility =
      if (isMenu || isExpanded) then
        "visible"
      else
        "hidden"

    flexBasis =
      if (isMenu || isExpanded) then
        "20%"
      else
        "0%"

    styles =
      style
        [ ( "width", flexBasis )
        , ( "height", "100%" )
        , ( "display", "inline-block" )
        , ( "background-color", "blue" )
        -- , ( "visibility", visibility )
        , ( "border", "1px solid black" )
        ]

    expandHandler =
      Just issue.id
        |> ExpandIssue
        |> onClick address
  in
    section
      [ class "issue", styles, expandHandler ]
      [ text issue.symbol ]
