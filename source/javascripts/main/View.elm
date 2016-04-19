module View (..) where

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Model exposing (Model, Issue, isShowingMenu, findSelectedIssue)
import Update exposing (Action(..))
import Signal
import Issues.About


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
      (List.append
        (viewIssueMenu address model)
        [ viewSelectedIssue address model ]
      )


viewSelectedIssue : Signal.Address Action -> Model -> Html
viewSelectedIssue address model =
  case model.expandedIssueId of
    Just 1 ->
      viewIssueContent address (Issues.About.view address model)

    Just 2 ->
      viewIssueContent address (text "HI!")

    Just _ ->
      span [] []

    Nothing ->
      span [] []


viewIssueContent : Signal.Address Action -> Html -> Html
viewIssueContent address issueView =
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
        ]
  in
    div
      [ class "issue-content", styles ]
      [ closeButton closeHandler
      , issueView
      ]


closeButton : Html.Attribute -> Html
closeButton handler =
  let
    styles =
      style
        [ ( "float", "right" )
        , ( "padding-top", "20px" )
        , ( "padding-right", "20px" )
        , ( "padding-right", "20px" )
        , ( "font-size", "24px" )
        , ( "color", "white" )
        ]
  in
    span [ styles, handler ] [ text "✗" ]


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
        , ( "background-image", "url(" ++ issue.backgroundAsset ++ ")" )
        , ( "background-repeat", "no-repeat" )
        , ( "background-position", "center" )
        ]

    expandHandler =
      Just issue.id
        |> ExpandIssue
        |> onClick address
  in
    section
      [ class "issue", styles, expandHandler ]
      [ text issue.symbol ]
