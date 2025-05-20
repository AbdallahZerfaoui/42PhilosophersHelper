
**42PhilosophersHelper: Your New Best Friend for the Philosophers Project!**  

Your philo passes the obvious tests, but evaluation fails for reasons you can’t reproduce. I built **42PhilosophersHelper** after seeing these exact issues in evals. We built **42PhilosophersHelper** after seeing these exact issues in evals, and the more people who use and share it, the better it gets at catching these tricky bugs! **42PhilosophersHelper** automates the heavy lifting!  

*We're building this for the community – if you find it useful, sharing it helps us all improve it faster!*

**TL;DR:** Use this  :link: **GitHub**: [github.com/AbdallahZerfaoui/42PhilosophersHelper](https://github.com/AbdallahZerfaoui/42PhilosophersHelper)   to test your code :blush:  

**Why use it?**  
:white_check_mark: **Mixed logs:** Tests if your printfs get scrambled (impossible to see manually with fast philos!)  
:white_check_mark: **Semi-automated testing** for death conditions, meal limits, and invalid inputs  
:white_check_mark: Detects **threading issues** via Helgrind (Docker setup included)  
:white_check_mark: **Customizable tests** – add your scenarios in simple .txt files  
:white_check_mark: **Time-saver** – no more guessing if your philo survives edge cases  

**Quick Start:**  
```bash
git clone https://github.com/AbdallahZerfaoui/42PhilosophersHelper.git ~/42PhilosophersHelper
chmod +x ~/42PhilosophersHelper/test.sh

echo 'alias philotest="~/42PhilosophersHelper/test.sh"' >> ~/.zshrc && source ~/.zshrc
OR
echo 'alias philotest="~/42PhilosophersHelper/test.sh"' >> ~/.bashrc && source ~/.bashrc
```  
Now you can run **42PhilosophersHelper** from anywhere! Simply go into your project folder and run:

```bash
philotest
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

PS: Contributions welcome! Found a bug or have test ideas? Open an issue/PR. **And if you find this tool useful, please share it with your fellow cadets! More users mean more feedback and a faster path to making it even better for everyone.** :blush: :rocket:
