import std/strutils

type
  ElfRange = object
    first: int
    last: int

func toElfRange(x: string): ElfRange =
  let parts = x.split("-")
  result = ElfRange(first : parts[0].parseInt(), last : parts[1].parseInt())

func inRange(x: int, r: ElfRange): bool =
  result = x >= r.first and x <= r.last

func haveOverlap(r, other: ElfRange): bool =
  result = r.first.inRange(other) or r.last.inRange(other) or
    other.first.inRange(r) or other.last.inRange(r)

var ccount = 0
for line in lines("input.txt"):
  let
    parts = line.split(",")
    r1 = parts[0].toElfRange()
    r2 = parts[1].toElfRange()
  if haveOverlap(r1, r2):
    inc ccount
echo ccount
