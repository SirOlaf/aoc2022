import std/strutils
import std/sets

func getPriority(c: char): int =
  if c.isLowerAscii():
    result = int(c) - 96
  else:
    result = int(c) - 38

let
  filelines = block:
    let contents = readFile("input.txt")
    contents.splitLines()
  
var fullpriority = 0
for i in countup(0, len(filelines)-3, 3):
  let
    group = filelines[i ..< i+3]
    s0 = group[0].toHashSet()
    s1 = group[1].toHashSet()
    s2 = group[2].toHashSet()
  var shared = s0 * s1 * s2
  assert shared.len() == 1
  fullpriority += getPriority(shared.pop())
echo fullpriority
