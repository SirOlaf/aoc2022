import std/strutils
import std/math

var
  highest = 0
  cur: seq[int]
for l in lines("input.txt"):
  var s = l.strip()
  if s.len() == 0:
    let summed = cur.sum()
    if summed > highest:
      highest = summed
    cur.setLen(0)
  else:
    cur.add(s.parseInt())

let summed = cur.sum()
if summed > highest:
  highest = summed

echo highest
