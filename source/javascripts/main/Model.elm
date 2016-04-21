module Model (..) where

import Util exposing ((?==))
import Time exposing (Time)
import Array exposing (Array, fromList)
import Html exposing (..)


type alias Model =
  { issues : List Issue
  , expandedIssueId : Maybe Int
  , hoveredIssueId : Maybe Int
  , phraseAnimationState : AnimationState
  , currentPhraseIndex : Int
  , phrases : Array String
  , closingAnimating : Bool
  , closingAnimationState : Maybe AnimationState
  , maybeExpandedImage : Maybe Source
  }


type alias Source =
  String


type alias Issue =
  { id : Int
  , symbol : String
  , class : String
  , title : String
  , tagline : String
  , images : ImagePaths
  , quote : String
  , quoteCredit : String
  , quoteStory : String
  , actionButtonText : String
  }


type IssueState
  = MenuItem
  | Hovered
  | Selected
  | Hidden


init : Model
init =
  { issues = allIssues
  , expandedIssueId = Nothing
  , hoveredIssueId = Nothing
  , phraseAnimationState = initialAnimation
  , currentPhraseIndex = 0
  , phrases = otherwheresPhrases
  , closingAnimating = False
  , closingAnimationState = Nothing
  , maybeExpandedImage = Nothing
  }


type alias AnimationState =
  { prevClockTime : Time
  , elapsedTime : Time
  }


initialAnimation =
  { prevClockTime = 0.0
  , elapsedTime = (0 - 2.0)
  }


resetTime : AnimationState -> AnimationState
resetTime currentAnimationState =
  { prevClockTime = currentAnimationState.prevClockTime
  , elapsedTime = (0 - 2.0)
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


allIssues : List Issue
allIssues =
  [ disaster
  , comics
  , travel
  , truthOrFiction
  ]


type alias ImagePaths =
  ( String, String, String )


imagePaths : String -> ImagePaths
imagePaths issueFolder =
  let
    imagePath =
      "/assets/issues/" ++ issueFolder ++ "/"
  in
    ( imagePath ++ "img1.png"
    , imagePath ++ "img2.png"
    , imagePath ++ "img3.png"
    )


truthOrFiction : Issue
truthOrFiction =
  { id = 5
  , symbol = "I"
  , class = "volume1"
  , title = "Truth or Fiction"
  , tagline = "Volume 1, an epic truth statement"
  , images = imagePaths "truth_or_fiction"
  , quote = "Now his brain was a sundial in a bed of fog. Sure, there were moments the sun would peak through and it was right square at twelve o’clock. But then came the darkness, and then it was another day. Perhaps every hour was there, but not in any predictable order. And I’d bet some of the times were borrowed."
  , quoteCredit = "Joseph Bien-Kahn"
  , quoteStory = "Faces"
  , actionButtonText = "Sold Out"
  }


travel : Issue
travel =
  { id = 4
  , symbol = "II"
  , class = "volume2"
  , title = "Travel"
  , tagline = "Volume 1, an epic truth statement"
  , images = imagePaths "travel"
  , quote = "My Ghent is ten square blocks in size, and likely bears little resemblance to the objective Ghent one might find online, or in a guidebook, or in, well, Ghent."
  , quoteCredit = "Adam Wilson"
  , quoteStory = "Belgium"
  , actionButtonText = "Sold Out"
  }


comics : Issue
comics =
  { id = 3
  , symbol = "III"
  , class = "volume3"
  , title = "Comics"
  , tagline = "Volume 1, an epic truth statement"
  , images = imagePaths "comics"
  , quote = "He tells me that I probably haven’t heard of a character named Batgirl. Frantically and boastfully, I whip out Frank Miller’s All Star Batman and Robin and scan to the Batgirl cover. “Oh, Barb?” He races for his sister and aunt in the next room. My desire to challenge children often cuts short my interactions with them."
  , quoteCredit = "Andrew \"Dirtman\" Hine"
  , quoteStory = "On Comics"
  , actionButtonText = "Sold Out"
  }


disaster : Issue
disaster =
  { id = 2
  , symbol = "IV"
  , class = "volume4"
  , title = "Disaster"
  , tagline = "6 STORIES OF PERSONAL DISASTERS"
  , images = imagePaths "disaster"
  , quote = "There are big disasters like passing out and creating puddles of vomit on the carpet of a bar, and there are small disasters like the blindness that occurs from wanting more from your friends when there is no more of them to share."
  , quoteCredit = "Katie Wheeler-Dubin"
  , quoteStory = "Storm Season"
  , actionButtonText = "Sold Out"
  }


findSelectedIssue : Model -> Maybe Issue
findSelectedIssue model =
  model.issues
    |> List.filter (\issue -> issue.id ?== model.expandedIssueId)
    |> List.head


isShowingMenu : Model -> Bool
isShowingMenu model =
  case model.expandedIssueId of
    Just _ ->
      False

    Nothing ->
      True
