import std/strutils
import std/sequtils
import std/sugar
import std/deques
import std/algorithm

type
  Monkey = ref object
    items: Deque[int]
    op: MonkeyOp
    testdiv: int
    true_target: int
    false_target: int
    inspections: int
  
  OpType = enum
    Multiply
    Add
    Square
  MonkeyOp = object 
    val: int
    op: OpType

proc toOpType(c: char): OpType =
  case c
  of '*':
    OpType.Multiply
  of '+':
    OpType.Add
  else:
    raiseAssert("Bad operation: " & c)

proc toOpType(s: string): OpType =
  let parts = s.split()
  if parts[^1] == "old":
    result = OpType.Square
  else:
    result = parts[^2][0].toOpType()

proc toMonkeyOp(s: string): MonkeyOp =
  result.op = s.toOpType()
  if result.op != OpType.Square:
    result.val = s.split()[^1].parseInt()

proc doMonkeyOp(op: MonkeyOp, x: int): int =
  case op.op
  of OpType.Multiply:
    result = x * op.val
  of OpType.Add:
    result = x + op.val
  of OpType.Square:
    result = x * x

var
  input = readFile("input.txt")
  lines = input.splitLines()
  i = 0
  monkeys: seq[Monkey]
while i + 5 < lines.len():
  let curlines = lines[i .. i+5]
  let monkey = Monkey(
    items : curlines[1].split(": ")[1].split(", ").map(
      x => x.parseInt()
    ).toDeque(),
    op : curlines[2].toMonkeyOp(),
    testdiv : curlines[3].split()[^1].parseInt(),
    true_target : curlines[4].split()[^1].parseInt(),
    false_target : curlines[5].split()[^1].parseInt()
  )
  monkeys.add(monkey)

  i += 7

for round in 0 ..< 20:
  for monkey in monkeys:
    while monkey.items.len() > 0:
      inc monkey.inspections
      let new_worry = monkey.op.doMonkeyOp(monkey.items.popFirst()) div 3
      if new_worry mod monkey.testdiv == 0:
        monkeys[monkey.true_target].items.addLast(new_worry)
      else:
        monkeys[monkey.false_target].items.addLast(new_worry)


let sortedmonkeys = sorted(monkeys, (x, y) => cmp(x.inspections, y.inspections))
echo sortedmonkeys[^1].inspections * sortedmonkeys[^2].inspections
