import std/algorithm
import std/strutils

var
  sums: seq[int]
  cur = 0
for l in lines("input.txt"):
  var s = l.strip()
  if s.len() == 0:
    sums.add(cur)
    cur = 0
  else:
    cur = s.parseInt()

sums.add(cur)
sums.sort()

echo sums[^1] + sums[^2] + sums[^3]
