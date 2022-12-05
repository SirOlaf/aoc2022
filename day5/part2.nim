import std/deques
import std/strutils

type
  BoxInstruction = object
    count: int
    fromi: int
    toi: int

  ElfBoxes = object
    stacks: seq[Deque[char]]
    moves: seq[BoxInstruction]

func parseMove(line: string): BoxInstruction =
  let parts = line.split()
  result.count = parts[1].parseInt()
  result.fromi = parts[3].parseInt() - 1
  result.toi = parts[5].parseInt() - 1

func parseInput(contents: string): ElfBoxes =
  var
    lines = contents.splitLines()
    line_idx = 0

  # parse initial arrangement
  while true:
    let curline = lines[line_idx]
    if curline[0] == ' ':
      inc line_idx
      break

    var stack_idx = 0
    for i in countup(0, curline.len(), 4):
      if stack_idx >= result.stacks.len():
        result.stacks.add(default(Deque[char]))

      let curbox = curline[i+1]
      if curbox != ' ':
        result.stacks[stack_idx].addFirst(curbox)
      inc stack_idx

    inc line_idx

  # parse moves
  while line_idx < lines.len():
    let curline = lines[line_idx]
    if curline.len() > 0:
      result.moves.add(parseMove(curline))
    inc line_idx

proc takeFromTop(d: var Deque[char], count: int): Deque[char] =
  assert d.len() >= count
  for _ in 0 ..< count:
    result.addFirst(d.popLast())

proc putToTop(d: var Deque[char], other: Deque[char]) =
  for b in other:
    d.addLast(b)

proc runMoves(inp: var ElfBoxes) =
  for move in inp.moves:
    let moved = inp.stacks[move.fromi].takeFromTop(move.count)
    inp.stacks[move.toi].putToTop(moved)

var inp = readFile("input.txt").parseInput()
inp.runMoves()

var res = ""
for stack in inp.stacks:
  res.add(stack.peekLast())
echo res

