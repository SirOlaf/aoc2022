import std/strutils
import std/tables


type
  DirStructure = ref object
    subdirs: Table[string, DirStructure]
    files: Table[string, int]
    parent: DirStructure
    size: int

proc newDirStructure(parent: DirStructure): DirStructure =
  new(result)
  result.parent = parent
  result.subdirs = initTable[string, DirStructure]()
  result.files = initTable[string, int]()

proc addFile(self: DirStructure, name: string, size: int) =
  self.files[name] = size
  var a = self
  while not a.isNil():
    a.size += size
    a = a.parent

iterator walkDirs(self: DirStructure): DirStructure {.closure.} =
  for d in self.subdirs.values():
    yield d
    for w in d.walkDirs():
      yield w


var
  root = newDirStructure(nil)
  curdir = root

for line in lines("input.txt"):
  if line.len() == 0:
    continue

  if line.startsWith("$"):
    let
      parts = line.split()
      (command, args) = (parts[1], parts[2..^1])

    if command == "cd":
      assert args.len() == 1
      if args[0] == "/":
        curdir = root
      elif args[0] == "..":
        assert not curdir.parent.isNil()
        curdir = curdir.parent
      else:
        let newdir = newDirStructure(curdir)
        curdir.subdirs[args[0]] = newdir
        curdir = newdir
    elif command == "ls":
      discard
    else:
      raise newException(ValueError, "Unknown command: " & command)
  else:
    let parts = line.split()
    if parts[0] != "dir":
      let size = parts[0].parseInt()
      curdir.addFile(parts[1], size)


const
    totalspace = 70000000
    neededspace = 30000000
let missingspace = neededspace + root.size - totalspace

var smallestsize = root.size
for d in root.walkDirs():
  if d.size > missingspace and d.size < smallestsize:
    smallestsize = d.size
echo smallestsize
