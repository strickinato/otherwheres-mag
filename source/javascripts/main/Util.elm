module Util (..) where


(=>) : a -> b -> ( a, b )
(=>) =
  (,)


(?==) : a -> Maybe a -> Bool
(?==) item maybeItem =
  case maybeItem of
    Just checkItem ->
      item == checkItem

    Nothing ->
      False
