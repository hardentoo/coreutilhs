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
import System.FilePath.Posix (joinPath, splitPath)
import Text.Printf (printf)

-- Print the resolved path.
main ::  IO ()
main = do
  input <- getArgs
  case input of
    [] -> putStrLn "realpath: missing file operand"
    files -> forM_ files $ \f ->
      (canonicalizePath f >>= putStrLn)
        `catch` canonicalizeDirectory (basename f) (dirname f)
  where
    canonicalizeDirectory ::  String -> String -> IOError -> IO ()
    canonicalizeDirectory base dir _ =
      ((canonicalizePath . nulldot) base >>= \path ->
        printf "%s/%s\n" path dir) `catch` doesNotExist base dir
    doesNotExist ::  String -> String -> IOError -> IO ()
    doesNotExist base dir _ =
      printf "realpath: '%s'/%s: No such file or directory\n" base dir

nulldot ::  String -> String
nulldot s = if null s then "." else s

basename ::  String -> String
basename f = joinPath . init . splitPath $ f

dirname ::  String -> String
dirname f = last . splitPath $ f
