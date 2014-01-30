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
import System.Directory (canonicalizePath)
import System.Environment (getArgs)
import System.FilePath.Posix (takeBaseName, takeDirectory)
import Text.Printf (printf)

-- Print the resolved path.
main ::  IO ()
main = do
  input <- getArgs
  case input of
    [] -> putStrLn "realpath: missing file operand"
    files -> forM_ files $ \f ->
      (canonicalizePath f >>= putStrLn)
        `catch` canonicalizeDirectory (takeDirectory f) (takeBaseName f)
  where
    canonicalizeDirectory ::  String -> String -> IOError -> IO ()
    canonicalizeDirectory dir base _ =
      ((canonicalizePath . nulldot) dir >>= \path ->
        printf "%s/%s\n" path base) `catch` doesNotExist dir base
    doesNotExist ::  String -> String -> IOError -> IO ()
    doesNotExist dir base _ =
      printf "realpath: '%s'/%s: No such file or directory\n" dir base

nulldot ::  String -> String
nulldot s = if null s then "." else s
