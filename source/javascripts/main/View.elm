module View (..) where

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Model exposing (Model, Issue, isShowingMenu, findSelectedIssue)
import Update exposing (Action(..))
import Signal


view : Signal.Address Action -> Model -> Html
view address model =
  let
    styles =
      style
        [ ( "width", "100%" )
        , ( "height", "100%" )
        ]
  in
    div
      [ id "wrapper", styles ]
      ( List.append
          (viewIssueMenu address model)
          [ viewSelectedIssue address model ]
      )


viewSelectedIssue : Signal.Address Action -> Model -> Html
viewSelectedIssue address model =
  case findSelectedIssue model of
    Just issue ->
      viewIssueContent address issue

    Nothing ->
      span [] []

viewIssueContent : Signal.Address Action -> Issue -> Html
viewIssueContent address issue =
  let
    closeHandler =
      onClick address (ExpandIssue Nothing)

    styles =
      style
        [ ( "width", "80%" )
        , ( "height", "100%" )
        , ( "position", "absolute" )
        , ( "display", "inline-block" )
        , ( "float", "right" )
        , ( "background-color", "green" )
        ]

  in
    div
      [ class "issue-content", styles ]
      [ closeButton closeHandler
      , text issue.title
      ]

closeButton : Html.Attribute -> Html
closeButton handler =
  span [ handler ] [ text "X" ]


viewIssueMenu : Signal.Address Action -> Model -> List Html
viewIssueMenu address model =
  (List.map (viewIssueMenuItem address model) model.issues)


isSelectedIssue : Int -> Maybe Int -> Bool
isSelectedIssue issueId maybeSelectedId =
  (Maybe.withDefault 0 maybeSelectedId) == issueId


viewIssueMenuItem : Signal.Address Action -> Model -> Issue -> Html
viewIssueMenuItem address model issue =
  let
    isExpanded =
      (||)
        (isShowingMenu model)
        (isSelectedIssue issue.id model.expandedIssueId)

    ( visibility, width ) =
      if isExpanded then
        ( "visible", "20%" )
      else
        ( "hidden", "0%" )

    styles =
      style
        [ ( "width", width )
        , ( "visibility", visibility )
        , ( "height", "100%" )
        , ( "display", "inline-block" )
        , ( "background-color", issue.backgroundColor )
        ]

    expandHandler =
      Just issue.id
        |> ExpandIssue
        |> onClick address
  in
    section
      [ class "issue", styles, expandHandler ]
      [ text issue.symbol ]
