module View (..) where

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Model exposing (Model, Issue, isShowingMenu, Source, SpecificIssue(..), issueFromIssueType, IssueState(..))
import Update exposing (Action(..))
import Signal
import Issues.About
import String


view : Signal.Address Action -> Model -> Html
view address model =
  div
    [ id "wrapper" ]
    (List.append
      (viewMenu address model)
      [ viewSelectedIssue address model ]
    )


viewMenu : Signal.Address Action -> Model -> List Html
viewMenu address model =
  let
    aboutMenu =
      (viewAboutMenuItem address model)

    issueMenuItems =
      (List.map (viewIssueMenuItem address model) model.issues)
  in
    aboutMenu :: issueMenuItems


viewSelectedIssue : Signal.Address Action -> Model -> Html
viewSelectedIssue address model =
  case model.expandedIssue of
    About ->
      Issues.About.view address model

    None ->
      span [] []

    expandedIssue ->
      viewFromIssue
        model.maybeExpandedImage
        (\maybeImgSource -> onClick address (ExpandImage maybeImgSource))
        (closeHandler address)
        (issueFromIssueType expandedIssue)


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
        , button [ class "issue-content-action-button" ] [ text (String.toUpper issue.actionButtonText) ] 
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


viewAboutMenuItem : Signal.Address Action -> Model -> Html
viewAboutMenuItem address model =
  let
    issueState =
      getIssueState About model

    attributes =
      issueStyle issueState "about" False model.closingAnimating

    handlers =
      handlersDependingOnState issueState About address

    logoAttributes name link =
      [ class name
      , href link
      , target "_blank"
      ]

    logos =
      div
        [ class "logo-space"
        , style [ ( "opacity", logoSpaceVisibility ) ]
        ]
        [ a (logoAttributes "facebook" "https://www.facebook.com/otherwheres") []
        , a (logoAttributes "twitter" "https://twitter.com/otherwheresmag") []
        , a (logoAttributes "instagram" "https://instagram.com/") []
        ]

    logoSpaceVisibility =
      case issueState of
        Selected ->
          if model.closingAnimating then
            "0"
          else
            "1"

        _ ->
          "0"

    subText =
      case issueState of
        MenuItem ->
          [ p [] [ text "{ mostly } true" ]
          , p [] [ text "stories" ]
          ]

        Hovered ->
          [ p [] [ text "who are we" ] ]

        Selected ->
          [ p [] [ text "who are we" ] ]

        Hidden ->
          [ p [] [ text "{ mostly } true" ]
          , p [] [ text "stories" ]
          ]
  in
    section
      (List.append handlers attributes)
      [ div
          [ innerStyle ]
          [ div
              [ class "red-logo" ]
              [ logos ]
          , div [ class "logo-text" ] [ text "OTHERWHERES" ]
          , div
              [ class "tag-line-text" ]
              subText
          ]
      ]


handlersDependingOnState : IssueState -> SpecificIssue -> Signal.Address Action -> List Html.Attribute
handlersDependingOnState state issueType address =
  case state of
    Hidden ->
      []

    Selected ->
      [ closeHandler address ]

    _ ->
      [ makeHoverHandler address issueType
      , makeExpandHandler address issueType
      ]


getIssueState : SpecificIssue -> Model -> IssueState
getIssueState specificIssue model =
  if isShowingMenu model then
    if (specificIssue == model.hoveredIssue) then
      Hovered
    else
      MenuItem
  else if (specificIssue == model.expandedIssue) then
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


makeHoverHandler : Signal.Address Action -> SpecificIssue -> Html.Attribute
makeHoverHandler address issueType =
  issueType
    |> HoverIssue
    |> onMouseOver address


makeExpandHandler : Signal.Address Action -> SpecificIssue -> Html.Attribute
makeExpandHandler address issueType =
  issueType
    |> ExpandIssue
    |> onClick address


closeHandler : Signal.Address Action -> Html.Attribute
closeHandler address =
  onClick address (ExpandIssue None)


viewIssueMenuItem : Signal.Address Action -> Model -> Issue -> Html
viewIssueMenuItem address model issue =
  let
    issueState =
      getIssueState issue.issueType model

    attributes =
      issueStyle issueState issue.class True model.closingAnimating

    handlers =
      handlersDependingOnState issueState issue.issueType address
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
      case getIssueState issue.issueType model of
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
