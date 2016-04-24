module Mobile.View (..) where

import Html exposing (..)
import Html.Attributes exposing (..)

view : Html
view =
  div
    [ id "mobile-wrapper" ]
    [ div [class "red-logo" ] []
    , div [class "logo-text"] [ text "OTHERWHERES" ]
    , div [ class "tag-line-text" ]
      [ p [] [ text "{ mostly } true" ]
      , p [] [ text "stories" ]
      ]
    , div
        [ class "mobile-explanatory-text"]
        [ p [] [ text "This screen is hella small" ] 
        , p [] [ text "We're currently working hard on a version of our site that works well on screens like this one. " ]
        , p [] [ text "Until then, check us out on your computer (or make your browser bigger)." ]
        ]
    ]
