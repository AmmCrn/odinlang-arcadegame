# An arcade game made in Odin-lang

# 🔧 Learning Odin with a Game Project 🎮

Welcome to my experimental game project written in [**Odin**](https://odin-lang.org/) — a modern programming language built for systems programming and performance.

This project is my hands-on way of learning **lower-level programming** concepts like memory management, resource loading, and direct control over data — without the hand-holding of higher-level languages. I decided on using Odin as the language since it is built with data-oriented design in mind as well as game development, for which it has built-in libraries such as raylib.

---

## 🚀 Learning Goals

- Build a simple 2D game from scratch using Odin
- Understand low-level systems like:
  - File I/O
  - Manual memory allocation
  - Rendering and texture management (more or less handled by raylib)
  - Code generation pre-compilation
- Learn by doing, breaking things, and fixing them

---

## 🕹️ Game Goals

The end goal is to build a simple Galaga-sytle arcade shooter. The current basic goals are:

- Have some sort of state machine or room state logic (main menu, game, other screens)
- Have the player move side to side to shoot enemies that come in waves
- A level/stage system with each level ending in a boss fight
- A sidebar with a scoreboard, upgrades and information

> More gameplay features that are unique to this game may happen as I explore further.

---

## 🔨 Build & Run

### 🧱 Prerequisites

- [Odin](https://odin-lang.org/download/)
- A C compiler (I believe clang specifically is needed for odin)

### ⚙️ Build Steps

Currently I am working on this on a linux system and as such I am using bash scripts to build and run the project. Right now you can simply run ``run.sh`` to run the game. It will do all the code generation it needs to and then compile and run the actual game source code.