# ToDoList VIPER

A simple to-do list application

## Architecture

The application is built using the **VIPER** architecture pattern:
- **View** — displays UI, forwards user actions to Presenter
- **Interactor** — business logic, data operations
- **Presenter** — mediator between View and Interactor
- **Entity** — data models
- **Router** — navigation between screens

## Tech Stack

- **UIKit** — programmatic UI (no Storyboard)
- **CoreData** — local task persistence
- **URLSession** — loads tasks from API on first launch
- **GCD** — multithreading, all data operations run on background thread
- **XCTest** — unit tests

## Features

- Display task list
- Add new task
- Edit existing task
- Delete task (swipe or context menu)
- Search tasks by title and description
- Toggle task completion status
- Load tasks from [DummyJSON API](https://dummyjson.com/todos) on first launch
- Persist data in CoreData across app launches

## Screenshots

<p align="left">
  <img src="Screenshots/screen1.png" width="220">
  <img src="Screenshots/screen2.png" width="220">
  <img src="Screenshots/screen3.png" width="220">
</p>

## Project Structure
```
ToDoListVIPER/
├── Modules/
│   ├── TaskList/          — main screen
│   │   ├── View/
│   │   ├── Presenter/
│   │   ├── Interactor/
│   │   ├── Router/
│   │   └── Entity/
│   └── TaskDetail/        — add/edit screen
│       ├── View/
│       ├── Presenter/
│       ├── Interactor/
│       └── Router/
├── Services/
│   ├── CoreDataService.swift
│   ├── NetworkService.swift
│   └── TaskEntity+Mapping.swift
└── Resources/
    └── Extensions/
        └── UIColor+App.swift
```

## Unit Tests

- `TaskListPresenterTests` — 7 tests
- `TaskDetailPresenterTests` — 6 tests
- `TodoDTOMappingTests` — 5 tests

## Requirements

- iOS 13+
- Xcode 15+

## Setup

1. Clone the repository
2. Open `ToDoListVIPER.xcodeproj`
3. Run on simulator or device
4. On first launch, tasks will be automatically loaded from the API
