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

proc findStart(map: Map): Coord = map.findChar(startChar)
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

proc countShortestPath(map: Map): int =
  # breadth first search
  var
    visitedCoords = initTable[Coord, Coord]()
    queue = initDeque[Coord]()
  let
    startCoord = map.findStart()
    endCoord = map.findEnd()
  var current = startCoord
  visitedCoords[current] = (x: -1, y: -1)
  while current != endCoord:
    for neighbor in map.getPossibleNeighbors(current):
      if neighbor in visitedCoords:
        continue
      visitedCoords[neighbor] = current
      queue.addLast(neighbor)
    current = queue.popFirst()
  var path = @[current]
  while current != startCoord:
    current = visitedCoords[current]
    path.add(current)
  path.len() - 1

let input = readFile("input.txt").strip().splitLines()
echo input.countShortestPath()
