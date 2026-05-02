# ♟️ Hnefatafl — Viking Chess AI

> A fully playable implementation of the ancient Viking strategy game, featuring an AI opponent powered by Alpha-Beta Pruning.

**Course:** CS361 — Artificial Intelligence  
**Institution:** Cairo University | Faculty of Computing and AI  
**Language:** Prolog (SWI-Prolog)

---

## 🎯 What is Hnefatafl?

Hnefatafl (pronounced *neh-fah-tah-fl*) is a two-player asymmetric strategy game played on an 11×11 board. Unlike chess, the two sides have **different goals and different numbers of pieces** — making it a fascinating testbed for adversarial AI.

| Side | Pieces | Goal |
|------|--------|------|
| Attackers | 24 soldiers | Surround and capture the King |
| Defenders | 12 soldiers + King | Escort the King to any corner |

**Rules at a glance:**
- All pieces move like a Rook in chess (any number of squares, horizontally or vertically)
- Pieces cannot jump over each other
- Capture is custodial: sandwich an enemy piece between two of yours (horizontally or vertically)
- Corners and the empty throne also assist in captures
- The King is unarmed — he cannot assist in capturing
- Attackers always move first
- Defenders win if the King reaches any corner; Attackers win if the King is surrounded on all sides

---

## AI — How it Works

The computer opponent uses **Alpha-Beta Pruning**, a classic adversarial search algorithm that explores the game tree while cutting off branches that cannot affect the final decision — making it far more efficient than plain Minimax.

The **heuristic evaluation function** scores any board state based on four factors:

| Factor | Description |
|--------|-------------|
| Piece count | Weighted difference between defender and attacker pieces remaining |
| King distance | Manhattan distance from the King to the nearest corner square |
| King mobility | Number of legal moves available to the King |
| Threat level | Number of attackers directly adjacent to the King |

### Difficulty Levels

| Level | Search Depth | Behaviour |
|-------|-------------|-----------|
| Easy | 1 | Looks 1 move ahead — makes occasional mistakes |
| Medium | 3 | Solid play — plans a few moves ahead |
| Hard | 5 | Strong play — hard to beat |

---

## Project Structure

```
hnefatafl/
├── main.pl               # Entry point — load this to start
├── src/
│   ├── board.pl          # Board representation, initial setup, pretty printing
│   ├── moves.pl          # Move generation, custodial capture, game-over detection
│   ├── heuristic.pl      # Utility / evaluation function
│   ├── alphabeta.pl      # Alpha-beta pruning algorithm + difficulty levels
│   └── controller.pl     # Game loop, human input, turn switching
├── team.txt              # Team members, IDs, groups & video link
└── README.md
```

### Module responsibilities

- **`board.pl`** — Defines the 11x11 board as a flat list, encodes special squares (throne, corners), handles piece placement and retrieval, and renders the board to the terminal.
- **`moves.pl`** — Generates all legal rook-style moves for a side, enforces path-clearing rules, implements custodial capture (including throne/corner assist and king-capture logic), and detects end-of-game conditions.
- **`heuristic.pl`** — Evaluates any board position from either player's perspective using piece counts, king proximity to escape corners, king mobility, and attacker threat pressure.
- **`alphabeta.pl`** — Implements negamax-style alpha-beta pruning. Exposes `best_move/4` as the single interface the controller calls to get the computer's move.
- **`controller.pl`** — Runs the game: prompts the human for side and difficulty, switches turns between human and computer, reads and validates human moves, and announces the winner.

---

## Getting Started

### Requirements
- [SWI-Prolog 8.x or higher](https://www.swi-prolog.org/Download.html)

### Run the game

```bash
swipl main.pl
```

The game launches automatically. Follow the prompts to pick your side and difficulty.

### How to enter a move

All moves are entered as a Prolog term followed by a period:

```prolog
move(FromRow, FromCol, ToRow, ToCol).
```

**Example** — move the piece at row 5, column 3 to row 5, column 0:
```prolog
move(5,3,5,0).
```

---

## Board Legend

| Symbol | Meaning |
|--------|---------|
| `K` | King |
| `A` | Attacker |
| `D` | Defender |
| `o` | Corner escape square |
| `x` | Throne (King's starting square) |
| `.` | Empty square |

---

## Team

See [`team.txt`](team.txt) for the full list of team members, student IDs, lab groups, and the link to the demo video.

---

## Grading Checklist

| Requirement | Status | File |
|-------------|--------|------|
| Board & state representation | Done | `src/board.pl` |
| Printing board after each move | Done | `src/board.pl` |
| Player switching (human vs computer) | Done | `src/controller.pl` |
| Representing possible moves | Done | `src/moves.pl` |
| Utility function | Done | `src/heuristic.pl` |
| Difficulty levels (easy / medium / hard) | Done | `src/alphabeta.pl` |
| Alpha-beta pruning | Done | `src/alphabeta.pl` |
| Prolog bonus (+1 mark) | Done | entire project |
| Human vs Computer mode | Done | `src/controller.pl` |
