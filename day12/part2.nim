import std/[
  strutils,
  tables,
  deques,
]


type
  Map = seq[string]
  Coord = tuple[x: int, y: int]

const
  startChar = 'S'
  endChar = 'E'


proc findChar(map: Map, c: char): Coord =
  for y in 0 ..< map.len():
    let x = map[y].find(c)
    if x >= 0:
      return (x: x, y: y)

proc findEnd(map: Map): Coord = map.findChar(endChar)


proc getHeight(map: Map, coord: Coord): int8 = 
  let c = block:
    let tmp = map[coord.y][coord.x]
    if tmp == startChar:
      'a'
    elif tmp == endChar:
      'z'
    else:
      tmp
  c.int8

proc getPossibleNeighbors(map: Map, coord: Coord): seq[Coord] =
  let curHeight = map.getHeight(coord)
  template put(xy: Coord) =
    if xy.x >= 0 and xy.x < map[0].len() and xy.y >= 0 and xy.y < map.len():
      let
        h = map.getHeight(xy)
        d = h - curHeight
      if d <= 1:
        result.add(xy)
  put((x: coord.x + 1, y: coord.y))
  put((x: coord.x - 1, y: coord.y))
  put((x: coord.x, y: coord.y + 1))
  put((x: coord.x, y: coord.y - 1))

proc countShortestPath(map: Map, startCoord: Coord): int =
  # breadth first search
  var
    visitedCoords = initTable[Coord, Coord]()
    queue = initDeque[Coord]()
  let endCoord = map.findEnd()
  var current = startCoord
  visitedCoords[current] = (x: -1, y: -1)
  while current != endCoord:
    for neighbor in map.getPossibleNeighbors(current):
      if neighbor in visitedCoords:
        continue
      visitedCoords[neighbor] = current
      queue.addLast(neighbor)
    if queue.len() == 0:
      break
    current = queue.popFirst()
  if current != endCoord:
    return high(int)
  var path = @[current]
  while current != startCoord:
    current = visitedCoords[current]
    path.add(current)
  path.len() - 1

let input = readFile("input.txt").strip().splitLines()
var shortest = high(int)
for y in 0 ..< input.len():
  let row = input[y]
  for x in 0 ..< row.len():
    if input.getHeight((x, y)) != 'a'.int8:
      continue
    let d = input.countShortestPath((x, y))
    if d < shortest:
      shortest = d
echo shortest
