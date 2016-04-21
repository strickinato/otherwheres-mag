module Issues.About (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import String
import Array


view address model =
  let
    currentPhrase =
      Maybe.withDefault "" (Array.get model.currentPhraseIndex model.phrases)

    styles =
      style
        [ ( "background-image", "url(assets/issues/about/bg.png)" )
        , ( "background-size", "cover" )
        , ( "background-position", "bottom" )
        , ( "height", "100%" )
        , ( "text-align", "center" )
        , ( "color", "white" )
        ]
  in
    div
      [ class "issue-content" ]
      [ div
          [ styles ]
          [ viewHeader
          , viewLiteIs
          , viewChangingText currentPhrase
          , viewLine
          ]
      ]


viewHeader : Html
viewHeader =
  let
    styles =
      style
        [ ( "padding-top", "96px" ) ]
  in
    h1 [ styles ] [ text ("OTHERWHERES") ]


viewLiteIs : Html
viewLiteIs =
  let
    styles =
      style
        [ ( "padding-top", "20px" )
        , ( "font-size", "26px" )
        ]
  in
    span [ styles, class "lite-italic" ] [ text "IS" ]


viewChangingText : String -> Html
viewChangingText currentText =
  let
    styles =
      style
        [ ( "padding-top", "20px" )
        , ( "font-size", "26px" )
        , ( "padding-bottom", "8px" )
        ]
  in
    h3 [ styles ] [ text (String.toUpper currentText) ]


viewLine : Html
viewLine =
  let
    styles =
      style
        [ ( "border", "1px solid " ++ grey )
        , ( "height", "0px" )
        , ( "width", "80%" )
        , ( "margin", "0 auto" )
        ]
  in
    div [ styles ] []


grey : String
grey =
  "#979797"
