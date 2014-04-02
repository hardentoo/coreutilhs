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

import Control.Exception (catch)
import Control.Monad (forM_)
import Data.Text (pack, toTitle, unpack)
import System.Environment (getArgs)
import System.IO.Error (ioeGetErrorString)
import System.Posix.Directory (removeDirectory)
import Text.Printf (printf)

-- Remove empty directories.
main ::  IO ()
main = do
  input <- getArgs
  case input of
    []   -> putStrLn "rmdir: missing file operand"
    dirs -> forM_ dirs $ \d -> removeDirectory d `catch` bork d

bork ::  String -> IOError -> IO ()
bork dir err =
  printf "cp: cannot stat '%s': %s\n" dir $
      unpack . toTitle . pack $ ioeGetErrorString err
