module View (..) where

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Model exposing (Model, Issue, isShowingMenu, findSelectedIssue, Source)
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
      Issues.About.view address model

    Just _ ->
      case findSelectedIssue model of
        Just issue ->
          viewFromIssue
            model.maybeExpandedImage
            (\maybeImgSource -> onClick address (ExpandImage maybeImgSource))
            (closeHandler address)
            issue

        Nothing ->
          span [] []

    Nothing ->
      span [] []


viewFromIssue : Maybe Source -> (Maybe Source -> Html.Attribute) -> Html.Attribute -> Issue -> Html
viewFromIssue maybeSource imgHandler closeHandler issue =
  let
    unexpanded =
      div
        [ class ("issue-content") ]
        [ div [ class "close-button", closeHandler ] []
        , div [ class "red-logo" ] []
        , h3 [ class "issue-number" ] [ text ("VOLUME " ++ issue.symbol ++ ":") ]
        , h3 [ class "issue-tagline" ] [ text issue.tagline ]
        , (issueImageView issue.images imgHandler)
        , div
            [ class "issue-quote" ]
            [ text issue.quote ]
        , div
            [ class "issue-quote-credit" ]
            [ text ("From " ++ issue.quoteStory ++ " by " ++ issue.quoteCredit) ]
        , button [ class "issue-content-action-button" ] [ text issue.actionButtonText ]
        ]

    expanded source =
      div
        [ class ("issue-content") ]
        [ div [ class "minimize-button", imgHandler Nothing ] []
        , img [ class "big-image", imgHandler Nothing, src source ] []
        ]
  in
    case maybeSource of
      Just src ->
        expanded src

      Nothing ->
        unexpanded


issueImageView : Model.ImagePaths -> (Maybe Source -> Html.Attribute) -> Html
issueImageView ( img1, img2, img3 ) handler =
  div
    [ class "images" ]
    [ img [ src img1, class "small", handler (Just img1) ] []
    , img [ src img2, class "small", handler (Just img2) ] []
    , img [ src img3, class "small", handler (Just img3) ] []
    ]


issueContentAttributes : List Html.Attribute
issueContentAttributes =
  let
    styles =
      style
        [ ( "width", "80%" )
        , ( "height", "100%" )
        , ( "position", "absolute" )
        , ( "display", "inline-block" )
        , ( "float", "right" )
        ]
  in
    [ class "issue-content", styles ]


viewIssueMenu : Signal.Address Action -> Model -> List Html
viewIssueMenu address model =
  (viewOtherwheresIssueItem address model)
    :: (List.map (viewIssueMenuItem address model) model.issues)


viewOtherwheresIssueItem : Signal.Address Action -> Model -> Html
viewOtherwheresIssueItem address model =
  let
    issueId =
      1

    issueState =
      getIssueState issueId model

    attributes =
      issueStyle issueState "about" False model.closingAnimating

    handlers =
      handlersDependingOnState issueState issueId address
  in
    section
      (List.append handlers attributes)
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


handlersDependingOnState : IssueState -> Int -> Signal.Address Action -> List Html.Attribute
handlersDependingOnState state id address =
  let
    whenMenuHandlers =
      [ makeHoverHandler address id
      , makeExpandHandler address id
      ]

    whenOpenHandlers =
      [ closeHandler address ]
  in
    case state of
      MenuItem ->
        whenMenuHandlers

      Hovered ->
        whenMenuHandlers

      Selected ->
        whenOpenHandlers

      Hidden ->
        []


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


issueStyle : IssueState -> String -> Bool -> Bool -> List Html.Attribute
issueStyle issueState issueClass redify closingAnimating =
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
          if closingAnimating then
            ( "visible", "20%", "solid white 2px", True )
          else
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


closeHandler : Signal.Address Action -> Html.Attribute
closeHandler address =
  onClick address (ExpandIssue Nothing)


viewIssueMenuItem : Signal.Address Action -> Model -> Issue -> Html
viewIssueMenuItem address model issue =
  let
    issueState =
      getIssueState issue.id model

    attributes =
      issueStyle issueState issue.class True model.closingAnimating

    handlers =
      handlersDependingOnState issueState issue.id address
  in
    section
      (List.append handlers attributes)
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
