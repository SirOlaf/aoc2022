import std/strutils
import std/sets

var
  cycle = 0
  x_register = 1
  strengthsum = 0

var next_cool = 20
template tick() =
  inc cycle
  if cycle == next_cool:
    strengthsum += cycle * x_register
    next_cool += 40

for line in lines("input.txt"):
  if line.len() == 0:
    continue

  let 
    parts = line.split()

  case parts[0]
  of "addx":
    tick()
    tick()
    x_register += parts[1].parseInt()
  of "noop":
    tick()
  else:
    assert false

echo strengthsum
