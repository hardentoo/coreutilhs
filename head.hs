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
- along with coreutilhs.  If not, see <http://www.gnu.org/licenses/>.
-} module Main where

import Control.Monad (forM_)
import System.Environment (getArgs)
import Text.Printf (printf)

-- Print the first ten lines of STDIN or given files.
main ::  IO ()
main = do
  input <- getArgs
  case input of
    []    -> interact (unlines . take 10 . lines)
    files -> forM_ files $ \file -> do
      contents <- readFile file
      printf "==> %s <==\n%s\n" file . unlines . take 10 $ lines contents
