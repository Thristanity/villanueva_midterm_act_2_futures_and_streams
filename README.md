# CC 105 – Applications Development and Emerging Technologies



## ACTIVITY: PICK YOUR OWN API



*Future, Stream & REST API Integration*

---

**Goal:** Integrate a Flutter application with a public REST API using Future and Stream constructs.

### What You're Building



| Screen | Powered by | What it shows |
| --- | --- | --- |
| Screen 1: The Order

 | FutureBuilder

 | Data you fetch once when the screen opens, shown as a list.

 |
| Screen 2: The Belt

 | StreamBuilder

 | Data that keeps updating on its own every few seconds.

 |

### Must-Haves



**Screen 1 (Future)**

* Loads once when the screen opens. No endless refetching.


* Shows a spinner while waiting.


* Shows an error message and a Retry button when it fails.


* Shows an "empty" message when there's nothing to show.


* Shows the real API data as a list.



**Screen 2 (Stream)**

* Updates on its own.


* Shows a loading state before the first data arrives.


* Shows an error state when something goes wrong.


* One failed fetch must not kill the stream.



**Both screens**

* Every response becomes typed Dart objects with fromJson.


* Every request checks the status code and has a timeout.


* Survives the **airplane-mode test**: a classmate switches it on during your demo and your app must not crash.



### API Ground Rules



* Free, returns JSON, and needs **no API key or credit card**.


* Not JSONPlaceholder or Open-Meteo. Those were our class demo.


* Screen 2's data must **actually change**, or we can't see your Stream working. A "random something" endpoint or genuinely live data both work.


* Screen 1 and Screen 2 can use two endpoints of the same API, or two different APIs.


* Be nice to the server. Check its rate limits. Every 5 seconds is plenty.



**Where to hunt:** the public-apis list on GitHub ([github.com/public-apis/public-apis](https://www.google.com/search?q=https%3A%2F%2Fgithub.com%2Fpublic-apis%2Fpublic-apis)). Filter for APIs where Auth is "No".

### Build It



Use the lecture deck and study guide as your reference. Type the code yourself instead of pasting it. If you can't explain a line, it isn't yours yet, and I will ask.

**Submit on Google Classroom:** your GitHub repo link.