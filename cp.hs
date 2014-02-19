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
import Control.Monad (forM_, when)
import System.Directory (copyFile, doesDirectoryExist)
import System.Environment (getArgs)
import System.IO.Error (isDoesNotExistError, isPermissionError)
import Text.Printf (printf)

-- Copy source file to destination, or source files to destination directory.
main ::  IO ()
main = do
  files <- getArgs
  let ffile = head files
      lfile = last files
  case length files of
    0 -> putStrLn "cp: missing file operand"
    1 -> printf "cp: missing destination file operand after '%s'\n" ffile
    2 -> copyFile ffile lfile
    _ -> do
      d <- doesDirectoryExist lfile
      if d
        then forM_ files $ \f -> when (f /= lfile) $
          copyFile f (lfile ++ "/" ++ f) `catch` bork f
        else printf "cp: target '%s' is not a directory\n" lfile

bork ::  String -> IOError -> IO ()
bork dir err = printf "cp: cannot stat '%s': %s\n" dir reason
  where reason
          | isPermissionError   err = "Permission denied"
          | isDoesNotExistError err = "No such file or directory"
          | otherwise               = "Something went wrong"
