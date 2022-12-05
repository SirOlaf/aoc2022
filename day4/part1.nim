import std/strutils

type
  ElfRange = object
    first: int
    last: int

func toElfRange(x: string): ElfRange =
  let parts = x.split("-")
  result = ElfRange(first : parts[0].parseInt(), last : parts[1].parseInt())

func size(r: ElfRange): int =
  result = r.last - r.first

func containsOther(r, other: ElfRange): bool =
  if r.size() == other.size():
    return r.first == other.first and r.last == other.last
  elif r.size() > other.size():
    return other.first >= r.first and other.last <= r.last
  else:
    return r.first >= other.first and r.last <= other.last

template oneContained(r1, r2: ElfRange): bool =
  r1.containsOther(r2) or r2.containsOther(r1)

var ccount = 0
for line in lines("input.txt"):
  let
    parts = line.split(",")
    r1 = parts[0].toElfRange()
    r2 = parts[1].toElfRange()
  if oneContained(r1, r2):
    inc ccount
echo ccount
