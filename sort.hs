{-
- Copyright (C) 2014 Allen Guo <guoguo12@gmail.com>
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

import Data.List (sort)
import System.Environment (getArgs)

main = do
  input <- getArgs
  case input of
    [] -> fmap (sort . lines) getContents >>= mapM_ putStrLn
    files -> fmap (sort . lines) (readFile $ files !! 0) >>= mapM_ putStrLn