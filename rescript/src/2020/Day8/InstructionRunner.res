open Belt
open InstructionModel

let reducer = (action, appState) => {
  switch action {
  | None => appState
  | Some(instruction) => {
      let numberOfCurrentInstructionVisited = Option.getWithDefault(
        appState.numberOfInstructionsVisited[appState.currentInstructionIndex],
        0,
      )

      let increaseInstructionVisitedCounter = () => {
        {
          appState.numberOfInstructionsVisited[
            appState.currentInstructionIndex
          ] =
            numberOfCurrentInstructionVisited + 1
        }->ignore
      }

      switch instruction {
      | NoOp => {
          increaseInstructionVisitedCounter()
          {
            ...appState,
            currentInstructionIndex: appState.currentInstructionIndex + 1,
          }
        }

      | Accumulate(arg) => {
          increaseInstructionVisitedCounter()
          {
            ...appState,
            currentInstructionIndex: appState.currentInstructionIndex + 1,
            accumulator: appState.accumulator + arg,
          }
        }

      | Jump(arg) => {
          increaseInstructionVisitedCounter()
          {
            ...appState,
            currentInstructionIndex: appState.currentInstructionIndex + arg,
          }
        }
      }
    }
  }
}

let terminationTest = (appState: InstructionModel.appState, instructions) => {
  let numberOfCurrentInstructionVisited = Option.getWithDefault(
    appState.numberOfInstructionsVisited[appState.currentInstructionIndex],
    0,
  )

  numberOfCurrentInstructionVisited > 0 ||
    Option.isNone(instructions[appState.currentInstructionIndex])
}

let rec runInstruction = (terminationTest, appState: InstructionModel.appState, instructions) => {
  if terminationTest(appState, instructions) {
    appState
  } else {
    runInstruction(
      terminationTest,
      reducer(instructions[appState.currentInstructionIndex], appState),
      instructions,
    )
  }
}
