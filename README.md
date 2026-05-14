# Hnefatafl AI Project

## Faculty of Computing and Artificial Intelligence – Cairo University

### CS361: Artificial Intelligence

A complete implementation of the ancient Viking strategy game **Hnefatafl** with an Artificial Intelligence opponent using the **Alpha-Beta Pruning Algorithm**.

---

# Project Overview

Hnefatafl, also known as *Viking Chess*, is a two-player asymmetric strategy board game.

The game consists of:

* **Attackers (Black Army)** → 24 soldiers
* **Defenders (White Army)** → 12 soldiers and 1 King

The defending side aims to help the King escape to one of the four corner squares, while the attackers attempt to capture the King before he escapes.

This project was developed as part of the **CS361 Artificial Intelligence course** at entity["organization","Cairo University","Giza, Egypt"].

---

# Game Rules

## Board Setup

* The board size is either **9x9** or **11x11**.
* The King starts in the center square called the **Throne**.
* 12 defenders surround the King.
* 24 attackers are positioned around the edges of the board.

---

## Piece Movement

* All pieces move like a **Rook in Chess**.
* Pieces can move:

  * Horizontally
  * Vertically
* Pieces may move any number of empty squares.
* Pieces cannot:

  * Move diagonally
  * Jump over other pieces
  * Move outside the board
  * Share the same square

---

## Capturing Mechanism

A piece is captured when trapped between two enemy pieces horizontally or vertically.

Special cases:

* A piece may also be captured between:

  * A corner square and an enemy piece
  * The throne and an enemy piece
* The King cannot assist in captures because he is considered unarmed.
* Pieces may pass through dangerous positions but cannot stop there.

---

## Winning Conditions

### Defender Victory

The defenders win if:

* The King reaches any corner square.

### Attacker Victory

The attackers win if:

* The King is surrounded on all four sides.
* If the King is beside a wall → attackers only need to surround the other three sides.
* If the King is beside a corner → attackers only need to surround the remaining two sides.

---

# Artificial Intelligence

The computer player is implemented using the:

## Alpha-Beta Pruning Algorithm

The AI searches possible moves and evaluates game states while pruning unnecessary branches to improve performance.

The implementation includes:

* Game state representation
* Move generation
* Utility / heuristic evaluation function
* Alpha-beta pruning
* Turn management
* Win condition detection

---

# Difficulty Levels

The game supports multiple difficulty levels based on search depth:

| Difficulty | Search Depth |
| ---------- | ------------ |
| Easy       | 1            |
| Medium     | 3            |
| Hard       | 5            |

---

# Features

* Human vs Computer gameplay
* Alpha-Beta pruning AI
* Board state representation
* Legal move validation
* Capture mechanics
* Dynamic board updates
* Turn switching system
* Difficulty levels
* End game detection
* Optional GUI support

---

# Technologies Used

## Programming Language

* Python / Prolog

## Concepts

* Artificial Intelligence
* Game Theory
* Search Algorithms
* Adversarial Search
* Heuristic Evaluation
* State Space Representation

---

# Project Structure

```bash
Hnefatafl/
│
├── assets/                # Images and resources
├── src/
│   ├── board.py           # Board representation
│   ├── controller.py      # Game controller
│   ├── ai.py              # Alpha-beta pruning implementation
│   ├── utility.py         # Heuristic evaluation function
│   ├── moves.py           # Move generation and validation
│   └── main.py            # Main game loop
│
├── README.md
├── requirements.txt
└── team.txt
```


# Team Members

Add team members here:

| Name     | ID       | Group |
| -------- | -------- | ----- |
| Muhannad | 20231182 | S1.2    |

---

# License

This project was developed for educational purposes as part of the CS361 Artificial Intelligence course at Cairo University.

