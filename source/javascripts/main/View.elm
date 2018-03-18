module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Issues.About
import Mobile.View
import Model exposing (DisplayImage(..), Issue, IssueState(..), Model, Screen(..), SpecificIssue(..), isShowingMenu, issueFromIssueType, midScreen)
import String
import Update exposing (Msg(..))


view : Model -> Html Msg
view model =
    case model.screen of
        TooSmall ->
            Mobile.View.view

        _ ->
            div
                [ id "wrapper" ]
                (List.append
                    (viewMenu model)
                    [ viewSelectedIssue model ]
                )


viewMenu : Model -> List (Html Msg)
viewMenu model =
    let
        aboutMenu =
            viewAboutMenuItem model

        issueMenuItems =
            List.map (viewIssueMenuItem model) model.issues
    in
    aboutMenu :: issueMenuItems


viewSelectedIssue : Model -> Html Msg
viewSelectedIssue model =
    case model.expandedIssue of
        About ->
            Issues.About.view model

        None ->
            span [] []

        expandedIssue ->
            viewFromIssue
                model.displayImage
                (\displayImage -> onClick (ExpandImage displayImage))
                (closeHandler )
                (issueFromIssueType expandedIssue)


viewFromIssue : DisplayImage -> (DisplayImage -> Html.Attribute Msg) -> Html.Attribute Msg -> Issue -> Html Msg
viewFromIssue displayImage imgHandler closeHandler issue =
    let
        closeButton =
            case displayImage of
                All ->
                    div [ class "close-button", closeHandler ] []

                _ ->
                    div [ class "minimize-button", imgHandler All ] []
    in
    div
        [ class "issue-content" ]
        [ closeButton
        , div [ class "red-logo" ] []
        , h3 [ class "issue-number" ] [ text ("VOLUME " ++ issue.symbol ++ ":") ]
        , h3 [ class "issue-tagline" ] [ text (String.toUpper issue.tagline) ]
        , issueImageView issue.images displayImage imgHandler
        , div
            [ class "issue-quote" ]
            [ text issue.quote ]
        , div
            [ class "issue-quote-credit" ]
            [ text ("From " ++ issue.quoteStory ++ " by " ++ issue.quoteCredit) ]
        , actionButton issue
        ]


actionButton : Issue -> Html Msg
actionButton issue =
    a
        (tictailHref issue)
        [ div
            [ class "issue-content-action-button" ]
            [ text (String.toUpper issue.actionButtonText) ]
        ]


tictailHref : Issue -> List (Html.Attribute Msg)
tictailHref issue =
    [ href issue.actionButtonHref, target "_blank" ]


issueImageView : Model.ImagePaths -> DisplayImage -> (DisplayImage -> Html.Attribute Msg) -> Html Msg
issueImageView images displayImage handler =
    let
        bigImageConstructor source =
            div
                [ class "big-image-center-helper redified" ]
                [ img [ src source, class "big-image", handler All ] [] ]

        imageList =
            [ img [ src images.left, class "small", handler Left ] []
            , img [ src images.middle, class "small", handler Middle ] []
            , img [ src images.right, class "small", handler Right ] []
            ]

        allImages =
            case displayImage of
                All ->
                    imageList

                Left ->
                    (::)
                        (bigImageConstructor images.left)
                        imageList

                Middle ->
                    (::)
                        (bigImageConstructor images.middle)
                        imageList

                Right ->
                    (::)
                        (bigImageConstructor images.right)
                        imageList
    in
    div
        [ class "images" ]
        allImages


issueContentAttributes : List ( Html.Attribute Msg)
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


viewAboutMenuItem : Model -> Html Msg
viewAboutMenuItem model =
    let
        issueState =
            getIssueState About model

        attributes =
            issueStyle issueState "about" False model.closingAnimating

        handlers =
            handlersDependingOnState issueState About

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
                , a (logoAttributes "instagram" "https://www.instagram.com/otherwheres_magazine/") []
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

        hovered =
            case issueState of
                Hovered ->
                    True

                _ ->
                    False

        logoTextClasses =
            classList
                [ ( "logo-text", True )
                , ( "mid-screen", midScreen model )
                , ( "hovered", hovered )
                ]

        logoClass =
            if hovered then
                class "grey-logo"
            else
                class "red-logo"

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
                [ logoClass ]
                [ logos ]
            , div [ logoTextClasses ] [ text "OTHERWHERES" ]
            , div
                [ class "tag-line-text" ]
                subText
            ]
        ]


handlersDependingOnState : IssueState -> SpecificIssue -> List ( Html.Attribute Msg)
handlersDependingOnState state issueType =
    case state of
        Hidden ->
            []

        Selected ->
            [ closeHandler ]

        _ ->
            [ makeHoverHandler issueType
            , makeExpandHandler issueType
            ]


getIssueState : SpecificIssue -> Model -> IssueState
getIssueState specificIssue model =
    if isShowingMenu model then
        if specificIssue == model.hoveredIssue then
            Hovered
        else
            MenuItem
    else if specificIssue == model.expandedIssue then
        Selected
    else
        Hidden


issueStyle : IssueState -> String -> Bool -> Bool -> List (Html.Attribute Msg)
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
                , ( "redified", redified && redify )
                ]
    in
    [ styles, classes ]


makeHoverHandler : SpecificIssue -> ( Html.Attribute Msg)
makeHoverHandler issueType =
    issueType
        |> HoverIssue
        |> onMouseOver


makeExpandHandler : SpecificIssue -> Html.Attribute Msg
makeExpandHandler issueType =
    issueType
        |> ExpandIssue
        |> onClick


closeHandler : Html.Attribute Msg
closeHandler =
    onClick (ExpandIssue None)


viewIssueMenuItem : Model -> Issue -> Html Msg
viewIssueMenuItem model issue =
    let
        issueState =
            getIssueState issue.issueType model

        attributes =
            issueStyle issueState issue.class True model.closingAnimating

        handlers =
            handlersDependingOnState issueState issue.issueType
    in
    section
        (List.append handlers attributes)
        [ viewMenuInner model issue ]


innerStyle : Html.Attribute Msg
innerStyle =
    style
        [ ( "display", "flex" )
        , ( "flex-direction", "column" )
        , ( "align-items", "center" )
        , ( "justify-content", "center" )
        , ( "height", "100%" )
        , ( "text-align", "center" )
        ]


viewMenuInner : Model -> Issue -> Html Msg
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
