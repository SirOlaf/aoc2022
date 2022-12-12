import std/sets
import std/strutils

type
  Pos = (int64, int64)

template distance(a, b: Pos, axis: static range[0..1]): int64 =
  a[axis] - b[axis]

template dirmul(x: int64): range[-1..1] =
  x div abs(x)

var
  headpos: Pos
  tail: seq[Pos]
  visited: HashSet[Pos]

tail.setLen(9)
visited.incl(headpos)

for line in lines("input.txt"):
  if line.len() == 0:
    continue

  let
    parts = line.split()
    direction = parts[0][0]
  var steps = parts[1].parseInt()
  
  while steps > 0:
    case direction
    of 'L':
      dec headpos[0]
    of 'R':
      inc headpos[0]
    of 'U':
      dec headpos[1]
    of 'D':
      inc headpos[1]
    else:
      assert false

    var prev = headpos
    for i in 0 ..< 9:
      let
        xadj = distance(prev, tail[i], 0)
        yadj = distance(prev, tail[i], 1)

      if abs(xadj) > 1:
        if abs(yadj) > 0:
          tail[i][1] += yadj.dirmul()
        tail[i][0] += xadj.dirmul()
      elif abs(yadj) > 1:
        if abs(xadj) > 0:
          tail[i][0] += xadj.dirmul()
        tail[i][1] += yadj.dirmul()

      prev = tail[i]
    visited.incl(tail[8])
    dec steps

echo visited.len()
