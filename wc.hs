{-
- Copyright (C) 2013 Alexander Berntsen <alexander@plaimi.net>
-
- This file is part of coreutilhs.
-
- bweakfwu is free software: you can redistribute it and/or modify
- it under the terms of the GNU General Public License as published by
- the Free Software Foundation, either version 3 of the License, or
- (at your option) any later version.
-
- bweakfwu is distributed in the hope that it will be useful,
- but WITHOUT ANY WARRANTY; without even the implied warranty of
- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- GNU General Public License for more details.
-
- You should have received a copy of the GNU General Public License
- along with bwekfwu  If not, see <http://www.gnu.org/licenses/>.
-} module Main where

import Control.Applicative ((<$>))
import Data.Monoid (Monoid, mappend, mconcat, mempty)
import System.Environment (getArgs)
import Text.Printf (printf)

data Counter =
  Counter {
          cha :: Int, -- Characters.
          wor :: Int, -- Words.
          lin :: Int  -- Lines.
          }

instance Monoid Counter where
  mempty = Counter 0 0 0
  mappend (Counter c w l) (Counter c' w' l') =
    Counter (c + c') (w + w') (l + l')

-- Count the number of chars, words & lines of STDIN or given files.
main ::  IO ()
main = do
  input <- getArgs
  case input of
    []    -> interact countStdin
    files -> handleFiles files >>= putStr
  where handleFiles files = countFiles . zip files <$> mapM readFile files

countStdin ::  String -> String
countStdin s = printf "%s\n" $ (formatCounter . count) s

countFiles ::  [(FilePath, String)] -> String
countFiles xs =
  concat (zipWith formatFile counters paths) ++ total counters
  where (counters, paths) = (map (count . snd) xs, map fst xs)

formatFile ::  Counter -> FilePath -> String
formatFile c = printf "%s %s\n" (formatCounter c)

count ::  String -> Counter
count s = Counter (length s) ((length . words) s) ((length . lines) s)

formatCounter :: Counter -> String
formatCounter c = printf "%10d%10d%10d" (lin c) (wor c) (cha c)

total ::  [Counter] -> String
total cs =
  printf "%10d%10d%10d total\n" l w c
  where Counter c w l = mconcat cs
