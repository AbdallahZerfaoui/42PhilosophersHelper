# 42PhilosophersHelper	


![GitHub last commit](https://img.shields.io/github/last-commit/AbdallahZerfaoui/42PhilosophersHelper)
![GitHub issues](https://img.shields.io/github/issues/AbdallahZerfaoui/42PhilosophersHelper)
![GitHub license](https://img.shields.io/github/license/AbdallahZerfaoui/42PhilosophersHelper)


![Concurrency in C language: The Dining Philosophers Problem](docs/philos.png)	

**42PhilosophersHelper** is a semi-automated testing tool designed for the **Philosophers** project in the **42 curriculum**. It helps you validate the correctness and robustness of your implementation by running various test cases and checking for compliance with expected behavior. 

This tool streamlines testing, identifies potential threading issues, and saves you time by automating repetitive tasks.


## 🤔 Important Assumptions

To work its magic, the tester needs to make a few assumptions about how your `philosophers` program behaves. If your project doesn't follow these conventions, the tester might give you a `KO` or freeze, even if your code seems to work on its own.

Please make sure your program meets these criteria:

#### 1. Argument Handling & Errors
*   **Invalid Input:** When given invalid arguments (e.g., non-numeric values, negative numbers, wrong number of arguments), your program must:
    1.  Print an error message to the standard output.
    2.  The error message **must contain the word "invalid"**. For example, `Error: Invalid arguments.` works perfectly.
    3.  **Exit immediately** with a non-zero status code. It should **not** start the simulation.

    ```bash
    # This should print an error and stop
    ./philo 4 800 200 200 -5 

    # The tester waits for "invalid" and an exit. It will freeze if you do this:
    # "Number of meals is invalid, but doing the simulation anyway!"
    ```

#### 2. Program Termination
*   The simulation must stop immediately under one of two conditions:
    *   A philosopher dies.
    *   All philosophers have eaten the required number of meals (if the `number_of_times_each_philosopher_must_eat` argument is provided).
*   The tester uses its own `timeout` as a safety net, but it expects your program to terminate correctly on its own.

#### 3. Output Formatting
*   The tester parses your program's output to check its status. The format must be **exactly** as specified in the project subject, without extra characters or missing spaces.
*   The standard format is: `timestamp_in_ms philo_id action`
    *   `100 1 has taken a fork`
    *   `200 2 is eating`
    *   `450 3 died`
*   Any deviation from this format will likely cause the test to fail.

#### 4. Atomic `printf` (No Mixed Logs)
*   Each status line must be printed in a single, atomic operation. This is usually achieved by protecting your `printf` calls with a mutex.
*   The "Mixed Logs" test specifically checks for this. If your output looks scrambled, it's a sign of a data race on `stdout`.

    ```bash
    # BAD ❌ (Mixed logs)
    102 1 is eati103 2 has taken a forkng
    
    # GOOD ✅ (Atomic logs)
    102 1 is eating
    103 2 has taken a fork
    ```

#### 5. Executable Name
*   The tester script (`test.sh`) looks for an executable named `philo` in the actual directory. Make sure your `Makefile` produces a binary with this name.



## Why Use 42PhilosophersHelper?

This tester goes beyond simple checks to save you hours of debugging.	

*   **✅ Comprehensive Test Suites:** Automatically runs dozens of scenarios covering invalid inputs, death conditions, and meal limits.
*   **⏱️ Precise Deadlock Detection:** Catches subtle deadlocks by verifying that your program terminates *only when it should*.
*   **Race Condition Detection**: Includes Helgrind integration via Docker to find tricky data races in your mutex implementation.
*   **User-Friendly Output**: Clear `[OK]` or `[KO]` results with progress bars and a final summary. No more manually scanning logs!


More tests can be added by editing the appropriate ```.txt``` files with the input and expected outcome.

![screenshot of tester being run](docs/helper_case_2.png)	

✨ **Found 42PhilosophersHelper useful for your Philosophers project?** ✨

Please consider **giving this repository a ⭐ Star!** It's a quick way to show your appreciation and helps significantly:
*   **Increases visibility:** More 42 students can find and benefit from it.
*   **Motivates development:** Your support encourages improvements and new features!

[![GitHub Stars](https://img.shields.io/github/stars/AbdallahZerfaoui/42PhilosophersHelper?style=social)](https://github.com/AbdallahZerfaoui/42PhilosophersHelper)
---
## Installation

1. Clone the repository in your root directory:

    ```bash
    git clone https://github.com/AbdallahZerfaoui/42PhilosophersHelper.git ~/42PhilosophersHelper
    ```

2. Ensure **42PhilosophersHelper** is executable by running:

	```bash
	chmod +x ~/42PhilosophersHelper/test.sh
	```

3. Add **42PhilosophersHelper** to Your Shell (.zshrc or .bashrc)

    ```bash
    echo 'alias philotest="~/42PhilosophersHelper/test.sh"' >> ~/.zshrc
	source ~/.zshrc

	echo 'alias philotest="~/42PhilosophersHelper/test.sh"' >> ~/.bashrc
	source ~/.bashrc
    ```

## Usage

Now you can run **42PhilosophersHelper** from anywhere! Simply go into your project folder and run:

```bash
philotest
```

If the project is not compiled already, **42PhilosophersHelper** will try to do it for you. So make sure your Makefile works properly!
### Custom Timer for Tests

During execution, the script prompts you to set a timer for the tests. You can:

1. **Enter a custom time** (in seconds) for each test run.
2. **Press Enter** to use the default timer (10 seconds).

The prompt:

```bash
Please enter desired timer for tests or press ENTER to use default (10 seconds):
```


## 🔧 Customizing Tests

You can easily add your own test cases to challenge your `philo` program. The tester reads scenarios from four `.txt` files located in the `42PhilosophersHelper` directory.

### Test Files

*   `no-die.txt`: Scenarios where **no philosopher should die**. The test passes if the simulation runs for the full duration without a death.
*   `yes-die.txt`: Scenarios where the simulation **must stop** before the timer ends. This can be due to a philosopher's death or because all philosophers have eaten enough.
*   `invalid_inputs.txt`: Scenarios with invalid arguments. The test passes if your program prints an error containing the word "invalid" and exits.
*   `limited_meals.txt`: Scenarios where the simulation must stop because the meal limit is reached. The test validates the total number of "is eating" logs.

### How to Add a Test

To add a new test, simply edit the appropriate `.txt` file. Each test case requires **exactly two lines**:

1.  **The arguments** for your `philo` program, separated by spaces.
2.  **A description** of the test case or the expected outcome. This description is printed to the console to help you follow along.

#### Example: Adding a test to `yes-die.txt`

Let's say you want to test a scenario where a philosopher dies quickly with `4 310 200 100`.

Open `yes-die.txt` and add the following two lines to the end of the file:

```text
4 310 200 100
A philosopher should die due to the short time_to_die.
```

## Helgrind Testing

Helgrind is used to detect potential threading issues in your `philo` program. However, running Helgrind requires a Docker environment due to its specific setup requirements. 

### Setting up Docker for Helgrind Tests
1. **Install Docker**: Ensure you have Docker installed on your system. If not, you can follow the installation guide [here](https://github.com/Scarletsang/Dorker).
2. **Start Docker**: Make sure Docker is running before proceeding with the tests.
3. **Run Helgrind Tests**: During the test selection, choose the option `Check Data Races && Deadlocks`. This will trigger the Helgrind checks within a Docker container.

### Notes
- Helgrind tests are optional but highly recommended for catching concurrency-related bugs.
- Ensure your program compiles correctly and all dependencies are included before running the tests.

## Credits
Timed-checker Python script ```PhilosophersChecker.py``` [(link)](https://gist.github.com/jkctech/367fad4aa01c820ffb1b8d29d1ecaa4d) was written by [JKCTech](https://gist.github.com/jkctech) and modified slightly by me [MichelleJiam](https://gist.github.com/jkctech).  
[Progress bar function](https://stackoverflow.com/a/52581824) written by Vagiz Duseev, found on StackOverflow.  

The bonus part was written by Jan Oltmann [(Github)](https://github.com/EstivalSolstice).
