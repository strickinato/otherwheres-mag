module View (..) where

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Model exposing (Model, Issue, isShowingMenu, findSelectedIssue)
import Update exposing (Action(..))
import Signal
import Issues.About
import String


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


type IssueState
  = MenuItem
  | Hovered
  | Selected
  | Hidden


getIssueState : Issue -> Model -> IssueState
getIssueState issue model =
  if isShowingMenu model then
    if (isSelectedIssue issue.id model.hoveredIssueId) then
      Hovered
    else
      MenuItem
  else
    if (isSelectedIssue issue.id model.expandedIssueId) then
      Selected
    else
      Hidden


viewIssueMenuItem : Signal.Address Action -> Model -> Issue -> Html
viewIssueMenuItem address model issue =
  let
    ( visibility, width, border, redified, blurred ) =
      case getIssueState issue model of
        MenuItem ->
          ( "visible", "20%", "solid white 2px", True, True )

        Hovered ->
          ( "visible", "20%", "solid white 2px", False, False )

        Selected ->
          ( "visible", "20%", "none", False, False )

        Hidden ->
          ( "hidden", "0%", "none", False, False )

    styles =
      style
        [ ( "width", width )
        , ( "visibility", visibility )
        , ( "height", "100%" )
        , ( "display", "inline-block" )
        , ( "border-left", border )
        , ( "border-right", border )
        ]

    hoverHandler =
      Just issue.id
        |> HoverIssue
        |> onMouseOver address

    expandHandler =
      Just issue.id
        |> ExpandIssue
        |> onClick address

    classes =
      classList
        [ ( "issue", True )
        , ( issue.class, True )
        , ( "blurred", blurred )
        , ( "redified", redified )
        ]
  in
    section
      [ classes, styles, expandHandler, hoverHandler ]
      [ viewMenuInner model issue ]


viewMenuInner : Model -> Issue -> Html
viewMenuInner model issue =
  let
    issueDisplay =
      case getIssueState issue model of
        MenuItem ->
          h1
            [ class "menu-issue-symbol" ]
            [ text issue.symbol ]
              
        Hovered ->
          span
            [ class "menu-issue-title" ]
            [ text (String.toUpper issue.title) ]

        Selected -> 
          span
            [ class "menu-issue-title" ]
            [ text (String.toUpper issue.title) ]

        Hidden ->
          span [] []

    styles =
      style
        [ ( "display", "flex" )
        , ( "flex-direction", "column" )
        , ( "align-items", "center" )
        , ( "justify-content", "center" )
        , ( "height", "100%" )
        , ( "text-align", "center" )
        ]
  in
    div
      [ styles ]
      [ issueDisplay ]
