import std/sets

type
  Node = ref object
    value: int
    coords: (int, int)
    prev, next: Node

  View = ref object
    head: Node
    middle: Node
    leftlen, rightlen: int
    doublemiddle: bool

proc newNode(x: int, coords: (int, int)): Node =
  new(result)
  result.value = x
  result.coords = coords

proc findHead(n: Node): Node =
  result = n
  while result.prev != nil:
    result = result.prev

iterator iter(n: Node): Node =
  var cur = n
  while cur != nil:
    yield cur
    cur = cur.next

iterator iterValues(n: Node): int =
  for c in n.iter():
    yield c.value

proc toCoordsSeq(n: Node): seq[(int, int)] =
  for v in n.iter():
    result.add(v.coords)

proc toValSeq(n: Node): seq[int] =
  for v in n.iterValues():
    result.add(v)

proc insert(v: View, x: int, coords: (int, int)) = 
  if v.middle == nil:
    v.middle = newNode(x, coords)
    v.head = v.middle
    return

  if x < v.middle.value:
    # add tail
    if v.middle.next == nil:
      v.middle.next = newNode(x, coords)
      inc v.rightlen
    # check right side, cut off tail if required
    else:
      var
        curlen = 1
        cur = v.middle.next
      while cur != nil:
        # cut off remaining tail and connect
        if x >= cur.value:
          cur.value = x
          cur.coords = coords
          cur.next = nil
          v.rightlen = curlen
          break
        # keep looking, maybe grow
        else:
          # grow
          if cur.next == nil:
            var n = newNode(x, coords)
            n.prev = cur
            cur.next = n
            inc v.rightlen
            break
        cur = cur.next
        inc curlen
  elif x > v.middle.value:
    # cut off right side
    v.middle.next = nil
    v.rightlen = 0
    
    # update middle
    var temp = v.middle
    v.middle = newNode(x, coords)
    v.middle.prev = temp
    temp.next = v.middle

    if v.doublemiddle:
      var t = v.middle
      v.middle = t.prev
      v.middle.next = t.next
      v.doublemiddle = false

    # can be seen from left by definition
    inc v.leftlen
  else:
    # cut off right side
    if (v.middle.next != nil and v.middle.next.value != v.middle.value) or v.middle.next.isNil() and not v.doublemiddle:
      # move middle to duplicate
      var n = newNode(x, coords)
      #n.next = v.middle.next
      v.middle.next = n
      n.prev = v.middle
      v.middle = n
      v.rightlen = 0
      v.doublemiddle = true
    else:
      if v.doublemiddle:
        var temp = v.middle
        v.middle = temp.prev
        v.middle.next = temp.next
        v.doublemiddle = false
      v.middle.next = nil
      v.rightlen = 0

proc size(v: View): int =
  v.leftlen + v.rightlen + 1 + int(v.doublemiddle)


var
  colviews: seq[View]
  rowviews: seq[View]

var x, y = 0
for line in lines("input.txt"):
  if line.len() == 0:
    continue

  if colviews.len() == 0:
    for _ in 0 ..< line.len():
      colviews.add(View(middle : nil))
  rowviews.add(View(middle : nil))
  
  x = 0
  for c in line:
    let b = cast[byte](c) - 48

    colviews[x].insert(int(b), (x, y))
    rowviews[y].insert(int(b), (x, y))

    inc x
  
  inc y


var
  othercount = 0
  seentrees: HashSet[(int, int)]
for v in rowviews:
  assert v.head == v.middle.findHead()
  for t in v.head.iter():
    seentrees.incl(t.coords)

  othercount += v.size()

for v in colviews:
  assert v.head == v.middle.findHead()
  for t in v.head.iter():
    if t.coords in seentrees:
      dec othercount

  othercount += v.size()

dec othercount
echo othercount
