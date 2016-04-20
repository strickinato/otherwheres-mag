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
  (viewOtherwheresIssueItem address model)
    :: (List.map (viewIssueMenuItem address model) model.issues)


viewOtherwheresIssueItem : Signal.Address Action -> Model -> Html
viewOtherwheresIssueItem address model =
  let
    issueId =
      1

    attributes =
      issueStyle (getIssueState issueId model) "about" False

    hoverHandler =
      makeHoverHandler address issueId

    expandHandler =
      makeExpandHandler address issueId
  in
    section
      (hoverHandler :: expandHandler :: attributes)
      [ div
          [ innerStyle ]
          [ div [ class "red-logo" ] []
          , div [ class "logo-text" ] [ text "OTHERWHERES" ]
          , div
              [ class "tag-line-text" ]
              [ text "{ mostly } true"
              , br [] [] 
              , text "stories"
              ]
          ]
      ]


isSelectedIssue : Int -> Maybe Int -> Bool
isSelectedIssue issueId maybeSelectedId =
  (Maybe.withDefault 0 maybeSelectedId) == issueId


type IssueState
  = MenuItem
  | Hovered
  | Selected
  | Hidden


getIssueState : Int -> Model -> IssueState
getIssueState id model =
  if isShowingMenu model then
    if (isSelectedIssue id model.hoveredIssueId) then
      Hovered
    else
      MenuItem
  else if (isSelectedIssue id model.expandedIssueId) then
    Selected
  else
    Hidden


issueStyle : IssueState -> String -> Bool -> List Html.Attribute
issueStyle issueState issueClass redify =
  let
    ( visibility, width, border, redified ) =
      case issueState of
        MenuItem ->
          ( "visible", "20%", "solid white 2px", True )

        Hovered ->
          ( "visible", "20%", "solid white 2px", False )

        Selected ->
          ( "visible", "20%", "none", False )

        Hidden ->
          ( "hidden", "0%", "none", False )

    styles =
      style
        [ ( "width", width )
        , ( "visibility", visibility )
        , ( "height", "100%" )
        , ( "float", "left" )
        , ( "display", "inline-block" )
        , ( "border-left", border )
        , ( "border-right", border )
        ]

    classes =
      classList
        [ ( "issue", True )
        , ( issueClass, True )
        , ( "redified", (redified && redify) )
        ]
  in
    [ styles, classes ]


makeHoverHandler : Signal.Address Action -> Int -> Html.Attribute
makeHoverHandler address id =
  Just id
    |> HoverIssue
    |> onMouseOver address


makeExpandHandler : Signal.Address Action -> Int -> Html.Attribute
makeExpandHandler address id =
  Just id
    |> ExpandIssue
    |> onClick address


viewIssueMenuItem : Signal.Address Action -> Model -> Issue -> Html
viewIssueMenuItem address model issue =
  let
    attributes =
      issueStyle (getIssueState issue.id model) issue.class True

    hoverHandler =
      makeHoverHandler address issue.id

    expandHandler =
      makeExpandHandler address issue.id
  in
    section
      (hoverHandler :: expandHandler :: attributes)
      [ viewMenuInner model issue ]


innerStyle : Html.Attribute
innerStyle =
  style
    [ ( "display", "flex" )
    , ( "flex-direction", "column" )
    , ( "align-items", "center" )
    , ( "justify-content", "center" )
    , ( "height", "100%" )
    , ( "text-align", "center" )
    ]


viewMenuInner : Model -> Issue -> Html
viewMenuInner model issue =
  let
    issueDisplay =
      case getIssueState issue.id model of
        MenuItem ->
          h1
            [ class "menu-issue-symbol" ]
            [ text issue.symbol ]

        Hovered ->
          h3
            [ class "menu-issue-title" ]
            [ text (String.toUpper issue.title) ]

        Selected ->
          h3
            [ class "menu-issue-title" ]
            [ text (String.toUpper issue.title) ]

        Hidden ->
          span [] []

    styles =
      innerStyle
  in
    div
      [ styles ]
      [ issueDisplay ]
