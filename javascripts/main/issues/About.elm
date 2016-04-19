module Issues.About (..) where

import Html exposing (..)
import Array


view address model =
  let
    currentPhrase =
      Maybe.withDefault "" (Array.get model.currentPhraseIndex model.phrases)
  in
    div [] [ text ("Otherwheres is " ++ currentPhrase) ]
