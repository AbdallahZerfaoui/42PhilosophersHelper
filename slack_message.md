
**42PhilosophersHelper: Your New Best Friend for the Philosophers Project!**  

Your philo passes the obvious tests, but evaluation fails for reasons you can’t reproduce. I built **42PhilosophersHelper** after seeing these exact issues in evals. **42PhilosophersHelper** automates the heavy lifting!  

**TL;DR:** Use this  :link: **GitHub**: [github.com/AbdallahZerfaoui/42PhilosophersHelper](https://github.com/AbdallahZerfaoui/42PhilosophersHelper)   to test your code :blush:  

**Why use it?**  
:white_check_mark: **Mixed logs:** Tests if your printfs get scrambled (impossible to see manually with fast philos!)  
:white_check_mark: **Semi-automated testing** for death conditions, meal limits, and invalid inputs  
:white_check_mark: Detects **threading issues** via Helgrind (Docker setup included)  
:white_check_mark: **Customizable tests** – add your scenarios in simple .txt files  
:white_check_mark: **Time-saver** – no more guessing if your philo survives edge cases  

**Quick Start:**  
```bash
git clone https://github.com/AbdallahZerfaoui/42PhilosophersHelper.git  
cd 42PhilosophersHelper && ./test.sh  
```

**Features you'll love:**  
- Default AND custom timers for stress-testing  
- Clear OK/KO results with test summaries  
- Prebuilt test cases + easy expansion  

**Perfect for:**  
- Final checks before evaluation  
- Hunting elusive data races  
- Validating edge cases (e.g., 200 philos, 1ms death timers)  

**Helgrind Users:** Docker integration makes thread debugging painless – highly recommended for catching sneaky concurrency bugs!  

:link: **GitHub**: [github.com/AbdallahZerfaoui/42PhilosophersHelper](https://github.com/AbdallahZerfaoui/42PhilosophersHelper)  

*"Because philosophers should die of hunger, not from your code bugs."*  

PS: Contributions welcome! Found a bug or have test ideas? Open an issue/PR :blush:  
