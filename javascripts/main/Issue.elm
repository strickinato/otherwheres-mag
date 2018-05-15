module Issue exposing (..)

import Navigation


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


type IssueState
    = MenuItem
    | Hovered
    | Selected
    | Hidden


allIssues : List Issue
allIssues =
    [ truthOrFiction
    , travel
    , comics
    , disaster
    ]


type SpecificIssue
    = Disaster
    | Comics
    | Travel
    | TruthOrFiction
    | About
    | Featured
    | None


fromHash : String -> SpecificIssue
fromHash hash =
    if hash == slug Disaster then
        Disaster
    else if hash == slug Comics then
        Comics
    else if hash == slug Travel then
        Travel
    else if hash == slug TruthOrFiction then
        TruthOrFiction
    else if hash == slug About then
        About
    else if hash == slug Featured then
        Featured
    else
        None


fromLocation : Navigation.Location -> SpecificIssue
fromLocation { hash } =
    fromHash hash


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


imagePaths : String -> ImagePaths
imagePaths issueFolder =
    let
        imagePath =
            "/assets/issues/" ++ issueFolder ++ "/"
    in
    { left = imagePath ++ "img1.png"
    , middle = imagePath ++ "img2.png"
    , right = imagePath ++ "img3.png"
    }


slug : SpecificIssue -> String
slug issueType =
    case issueType of
        Disaster ->
            "#/volume-4-disaster"

        Comics ->
            "#/volume-3-comics"

        Travel ->
            "#/volume-2-travel"

        TruthOrFiction ->
            "#/volume-1-truth-or-fiction"

        About ->
            "#/about"

        Featured ->
            "#/featured"

        None ->
            " "


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
    , actionButtonHref = "https://tictail.com/otherwheres/otherwheres-i-truth-and-fiction"
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
    , actionButtonHref = "https://tictail.com/otherwheres/otherwheres-ii-travel"
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
    , actionButtonHref = "https://tictail.com/otherwheres/otherwheres-iii-comics"
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
    , actionButtonText = "Buy"
    , actionButtonHref = "https://tictail.com/otherwheres/otherwheres-iv-disaster"
    }
