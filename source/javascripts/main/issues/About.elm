module Issues.About exposing (..)

import Array
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (Model, SpecificIssue(..), midScreen)
import String
import Update exposing (Msg(..))


view model =
    let
        currentPhrase =
            Maybe.withDefault "" (Array.get model.currentPhraseIndex model.phrases)

        closeHandler =
            onClick (ExpandIssue None)

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
            [ div [ class "close-button about", closeHandler ] []
            , viewHeader model
            , viewLiteIs
            , viewChangingText currentPhrase
            , viewLine
            , viewCurrentlyAccepting
            , viewNextIssueInfo
            , viewContactButton
            ]
        ]


viewHeader : Model -> Html Msg
viewHeader model =
    let
        classes =
            classList
                [ ( "about-header", True )
                , ( "mid-screen", midScreen model )
                ]
    in
    h1 [ classes ] [ text "OTHERWHERES" ]


viewLiteIs : Html Msg
viewLiteIs =
    span [ class "lite-italic" ] [ text "IS" ]


viewChangingText : String -> Html Msg
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


viewLine : Html Msg
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


viewCurrentlyAccepting : Html Msg
viewCurrentlyAccepting =
    div
        [ class "currently-accepting" ]
        [ text "Currently Accepting Submissions for Volume V:" ]


viewNextIssueInfo : Html Msg
viewNextIssueInfo =
    div
        [ class "next-issue" ]
        [ h3 [] [ text "UNDERTOW" ]
        , p [] [ text "Tell us your stories about rising tides, tugging currents, hidden traps, and whatever else \"undertow\" means to you" ]
        ]


viewContactButton : Html Msg
viewContactButton =
    a
        [ class "about-contact-link-button", href "mailto:jbienkhan@gmail.com" ]
        [ text "HIT US UP" ]


grey : String
grey =
    "#979797"
