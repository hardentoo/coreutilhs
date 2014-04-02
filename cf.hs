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

import Control.Applicative ((<$>))
import Control.Exception (catch)
import Control.Monad (forM_, unless)
import Data.Text (pack, toTitle, unpack)
import System.Directory (getDirectoryContents)
import System.Environment (getArgs)
import System.IO.Error (ioeGetErrorString)
import Text.Printf (printf)

-- Count number of files in a directory.
main ::  IO ()
main = do
  dirs <- getArgs
  if null dirs
    then printCount "."
    else forM_ dirs $ \d -> printCount d


printCount :: FilePath -> IO ()
printCount dir = do
  count <- countFiles dir
  unless (count == (-1)) $ print count

countFiles :: FilePath -> IO Int
countFiles dir = subtract 2 . length <$> filesIn dir

filesIn ::  FilePath -> IO [FilePath]
filesIn dir = getDirectoryContents dir `catch` bork dir

bork ::  String -> IOError -> IO [FilePath]
bork dir err = do
  printf "cf: cannot stat '%s': %s\n" dir $
      unpack . toTitle . pack $ ioeGetErrorString err
  return [""]
