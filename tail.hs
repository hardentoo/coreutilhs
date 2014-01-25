{-
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
- along with bwekfwu  If not, see <http://www.gnu.org/licenses/>.
-} module Main where

import Control.Monad (forM_)
import System.Environment (getArgs)
import Text.Printf (printf)

-- Print the last ten lines of STDIN or given files.
main ::  IO ()
main = do
  input <- getArgs
  case input of
    [] ->    interact (unlines . lastN 10 . lines)
    files -> forM_ files $ \file -> do
      contents <- readFile file
      printf "==> %s <==\n%s\n" file . unlines . lastN 10 $ lines contents

lastN ::  Int -> [String] -> [String]
lastN n s =
  zipOverflow s (drop n s)
  where zipOverflow :: [String] -> [String] -> [String]
        zipOverflow (_:xs) (_:ys) = zipOverflow xs ys
        zipOverflow xs     []     = xs
        zipOverflow []     ys     = ys
