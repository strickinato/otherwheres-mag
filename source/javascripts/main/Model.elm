module Model exposing (..)

import Array exposing (Array, fromList)
import Html exposing (..)
import Issue exposing (..)
import Navigation
import Time exposing (Time)


type alias Model =
    { issues : List Issue
    , expandedIssue : SpecificIssue
    , hoveredIssue : SpecificIssue
    , phraseAnimationState : AnimationState
    , currentPhraseIndex : Int
    , phrases : Array String
    , closingAnimating : Bool
    , closingAnimationState : Maybe AnimationState
    , displayImage : DisplayImage
    , screen : Screen
    , history : List Navigation.Location
    }


type Screen
    = Big
    | Medium
    | TooSmall


midScreen : Model -> Bool
midScreen model =
    case model.screen of
        Medium ->
            True

        _ ->
            False


type alias AnimationState =
    { prevClockTime : Time
    , elapsedTime : Time
    }


initialAnimation =
    { prevClockTime = 0.0
    , elapsedTime = 0 - 2.0
    }


resetTime : AnimationState -> AnimationState
resetTime currentAnimationState =
    { prevClockTime = currentAnimationState.prevClockTime
    , elapsedTime = 0 - 2.0
    }


otherwheresPhrases : Array String
otherwheresPhrases =
    fromList
        [ "mostly true"
        , "hella literary"
        , "awkward for your mom to read"
        , "delightfully tacky yet unrefined"
        , "memories unraveling at the seams"
        , "artsy fartsy"
        , "Capri-Sun and orange slices after the game"
        , "impressive coffee table material"
        , "a place to write the things we sometimes cannot say"
        , "a zine you can believe in"
        ]


currentPhrase : Model -> String
currentPhrase model =
    Maybe.withDefault "" (Array.get model.currentPhraseIndex model.phrases)


isShowingMenu : Model -> Bool
isShowingMenu model =
    case model.expandedIssue of
        None ->
            True

        _ ->
            False
