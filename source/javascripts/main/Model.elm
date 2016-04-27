module Model (..) where

import Util exposing ((?==))
import Time exposing (Time)
import Array exposing (Array, fromList)
import Html exposing (..)


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
  }


type alias Issue =
  { issueType : SpecificIssue
  , symbol : String
  , class : String
  , title : String
  , tagline : String
  , images : ImagePaths
  , quote : String
  , quoteCredit : String
  , quoteStory : String
  , actionButtonText : String
  , actionButtonHref : String
  }


type IssueState
  = MenuItem
  | Hovered
  | Selected
  | Hidden


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


init : Model
init =
  { issues = allIssues
  , expandedIssue = None
  , hoveredIssue = None
  , phraseAnimationState = initialAnimation
  , currentPhraseIndex = 0
  , phrases = otherwheresPhrases
  , closingAnimating = False
  , closingAnimationState = Nothing
  , displayImage = All
  , screen = Big
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


type SpecificIssue
  = Disaster
  | Comics
  | Travel
  | TruthOrFiction
  | About
  | None


issueFromIssueType : SpecificIssue -> Issue
issueFromIssueType issueType =
  case issueType of
    Disaster ->
      disaster

    Comics ->
      comics

    Travel ->
      travel

    TruthOrFiction ->
      truthOrFiction

    _ ->
      {- TODO Make default bad issue -}
      disaster


type alias ImagePaths =
  { left : String
  , middle : String
  , right : String
  }


type DisplayImage
  = All
  | Left
  | Middle
  | Right


imagePaths : String -> ImagePaths
imagePaths issueFolder =
  let
    imagePath =
      "/assets/issues/" ++ issueFolder ++ "/"
  in
    { left = imagePath ++ "img1.jpg"
    , middle = imagePath ++ "img2.jpg"
    , right = imagePath ++ "img3.jpg"
    }


truthOrFiction : Issue
truthOrFiction =
  { issueType = TruthOrFiction
  , symbol = "I"
  , class = "volume1"
  , title = "Truth and Fiction"
  , tagline = "5 Mostly True Stories"
  , images = imagePaths "truth_or_fiction"
  , quote = "Now his brain was a sundial in a bed of fog. Sure, there were moments the sun would peak through and it was right square at twelve o’clock. But then came the darkness, and then it was another day. Perhaps every hour was there, but not in any predictable order. And I’d bet some of the times were borrowed."
  , quoteCredit = "Joseph Bien-Kahn"
  , quoteStory = "Faces"
  , actionButtonText = "Buy"
  , actionButtonHref = "https://tictail.com/s/otherwheres/otherwheres-i-truth-and-fiction"
  }


travel : Issue
travel =
  { issueType = Travel
  , symbol = "II"
  , class = "volume2"
  , title = "Travel"
  , tagline = "7 Tales of Travel"
  , images = imagePaths "travel"
  , quote = "My Ghent is ten square blocks in size, and likely bears little resemblance to the objective Ghent one might find online, or in a guidebook, or in, well, Ghent."
  , quoteCredit = "Adam Wilson"
  , quoteStory = "Belgium"
  , actionButtonText = "Buy"
  , actionButtonHref = "https://tictail.com/s/otherwheres/otherwheres-ii-travel"
  }


comics : Issue
comics =
  { issueType = Comics
  , symbol = "III"
  , class = "volume3"
  , title = "Comics"
  , tagline = "5 Takes on the Comic"
  , images = imagePaths "comics"
  , quote = "He tells me that I probably haven’t heard of a character named Batgirl. Frantically and boastfully, I whip out Frank Miller’s All Star Batman and Robin and scan to the Batgirl cover. “Oh, Barb?” He races for his sister and aunt in the next room. My desire to challenge children often cuts short my interactions with them."
  , quoteCredit = "Andrew \"Dirtman\" Hine"
  , quoteStory = "On Comics"
  , actionButtonText = "Buy"
  , actionButtonHref = "https://tictail.com/s/otherwheres/otherwheres-iii-comics"
  }


disaster : Issue
disaster =
  { issueType = Disaster
  , symbol = "IV"
  , class = "volume4"
  , title = "Disaster"
  , tagline = "6 Stories of Personal Disaster"
  , images = imagePaths "disaster"
  , quote = "There are big disasters like passing out and creating puddles of vomit on the carpet of a bar, and there are small disasters like the blindness that occurs from wanting more from your friends when there is no more of them to share."
  , quoteCredit = "Katie Wheeler-Dubin"
  , quoteStory = "Storm Season"
  , actionButtonText = "Coming Soon"
  , actionButtonHref = "javascript:void(0)"
  }


isShowingMenu : Model -> Bool
isShowingMenu model =
  case model.expandedIssue of
    None ->
      True

    _ ->
      False
