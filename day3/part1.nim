import std/strutils
import std/sets

func getPriority(c: char): int =
  if c.isLowerAscii():
    result = int(c) - 96
  else:
    result = int(c) - 38

var fullpriority = 0
for l in lines("input.txt"):
  let
    csize = l.len() div 2
    s1 = l[0..<csize].toHashSet()
    s2 = l[csize..^1].toHashSet()
  var shared = s1 * s2
  assert shared.len() == 1
  let elem = shared.pop()
  fullpriority += getPriority(elem)
echo fullpriority
