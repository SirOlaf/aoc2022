import std/strutils

type
  Move = enum
    Rock
    Paper
    Scissors
    Invalid

  Outcome = enum
    Lose
    Draw
    Win
    Invalid

func toMove(c: char): Move =
  result = case c
  of 'A':
    Move.Rock
  of 'B':
    Move.Paper
  of 'C':
    Move.Scissors
  else:
    Move.Invalid

func toOutcome(c: char): Outcome =
  result = case c
  of 'X':
    Outcome.Lose
  of 'Y':
    Outcome.Draw
  of 'Z':
    Outcome.Win
  else:
    Outcome.Invalid

func getOutcome(me: Move, other: Move): Outcome =
  if me == other:
    return Outcome.Draw
  elif (me == Rock and other == Scissors) or 
    (me == Paper and other == Rock) or
    (me == Scissors and other == Paper):
    return Outcome.Win
  else:
    return Outcome.Lose

func getScore(me: Move, other: Move): int =
  result = int(me) + 1
  result += int(getOutcome(me, other)) * 3

func getMove(other: Move, outcome: Outcome): Move =
  if getOutcome(Move.Rock, other) == outcome:
    return Move.Rock
  elif getOutcome(Move.Paper, other) == outcome:
    return Move.Paper
  else:
    return Move.Scissors

var fullscore = 0
for l in lines("input.txt"):
  let
    s = l.split()
    (other, outcome) = (s[0][0].toMove(), s[1][0].toOutcome())
  fullscore += getScore(getMove(other, outcome), other)
echo fullscore
