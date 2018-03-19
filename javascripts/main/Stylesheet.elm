module Stylesheet exposing (..)

import Css exposing (..)
import Html
import Html.Attributes exposing (style)


styleDeclaration : List Mixin -> Html.Attribute
styleDeclaration =
    Css.asPairs >> Html.Attributes.style


wrapper : Html.Attribute
wrapper =
    styleDeclaration
        [ displayFlex
        , flexDirection column
        , alignItems stretch
        , height (pct 100.0)
        , width (pct 100.0)
        , backgroundColor black
        ]


chatSection : Html.Attribute
chatSection =
    styleDeclaration
        [ flex (int 2)
        ]


inputSection : Html.Attribute
inputSection =
    styleDeclaration
        [ flex (int 1)
        , width (pct 100.0)
        ]


black : Color
black =
    rgb 0 0 0
