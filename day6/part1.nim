import std/sets

var contents = readFile("input.txt")

proc arePreviousUnique(data: var string, off: int): bool =
  var seen: HashSet[char]
  for i in 0 ..< 4:
    let c = data[off - i]
    echo c
    if c in seen:
      return false
    seen.incl(c)
  result = true

for i in 3 ..< contents.len():
  if arePreviousUnique(contents, i):
    echo i + 1
    break
