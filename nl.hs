{-
- Copyright (C) 2014 Allen Guo <guoguo12@gmail.com>
- Copyright (C) 2014 Alexander Berntsen <alexander@plaimi.net>
-
- This file is part of coreutilhs.
-
- coreutilhs is free software: you can redistribute it and/or modify
- it under the terms of the GNU General Public License as published by
- the Free Software Foundation, either version 3 of the License, or
- (at your option) any later version.
-
- coreutilhs is distributed in the hope that it will be useful,
- but WITHOUT ANY WARRANTY; without even the implied warranty of
- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- GNU General Public License for more details.
-
- You should have received a copy of the GNU General Public License
- along with coreutilhs.  If not, see <http://www.gnu.org/licenses/>.
-} module Main where

import Control.Applicative ((<$>))
import System.Environment (getArgs)

-- Accepts and enumerates input from STDIN.
enumerateInput :: Int -> IO ()
enumerateInput n = join <$> getLine >>= putStrLn >> enumerateInput (n + 1)
  where join line = concat ["     ", show n, "  ", line]

-- Enumerates text.
enumerateText :: String -> String
enumerateText text = unlines $ zipWith join [1..] (lines text)
  where join n line = concat ["    ", show n, "  ", line]

main ::  IO ()
main = do
  files <- getArgs
  case files of
    [] -> enumerateInput 1
    files -> do
      text <- concat <$> mapM readFile files
      putStrLn $ enumerateText text
