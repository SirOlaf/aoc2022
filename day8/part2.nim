import std/strutils

template readTreeNum(data: seq[string], x, y: int): int =
  (cast[byte](data[y][x]) - 48).int

proc getScenicScore(data: seq[string]; x, y: int): int =
  let me = data.readTreeNum(x, y)

  # +x
  block:
    for xo in x+1 ..< data[y].len():
      inc result
      if data.readTreeNum(xo, y) >= me:
        break
  if result == 0:
    return

  # -x
  block:
    var s = 0
    for xo in countdown(x-1, 0):
      inc s
      if data.readTreeNum(xo, y) >= me:
        break
    result *= s
  if result == 0:
    return

  # +y
  block:
    var s = 0
    for yo in y+1 ..< data.len():
      inc s
      if data.readTreeNum(x, yo) >= me:
        break
    result *= s
  if result == 0:
    return

  # -y
  block:
    var s = 0
    for yo in countdown(y-1, 0):
      inc s
      if data.readTreeNum(x, yo) >= me:
        break
    result *= s

var data = readFile("input.txt").splitLines()

var bestscore = 0
for y in 0 ..< data.len():
  for x in 0 ..< data[y].len():
    let score = data.getScenicScore(x, y)
    echo score
    if score > bestscore:
      bestscore = score
echo bestscore
