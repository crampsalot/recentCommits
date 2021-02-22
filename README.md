# recentCommits
We’re looking forward to getting together and digging into some code.
In advance of that, we would like you to do the following:
1. Create a free GitHub account (if you do not already have one)
2. Create a new GitHub repository
3. Create a mobile app using Java, Swift or React Native that accomplishes the following:
  - Connects to the GitHub API;
  - Uses that API to retrieve the most recent commits (at least 25) Note: if you are using Android, try to use Dagger
  - Displays those commits in a list with the author, commit hash, and commit message.

As you create this app, please make frequent commits of your work in progress because we want to be able to follow the
process you went through in creating the app. We would like you to provide the link to your public GitHub repo.
Please include any unit tests you performed on this app.

## API used
 https://api.github.com/repos/{owner}/{repo}/commits?per_page=25

## Assumptions
 - The commits returned are for a specific repo for a specific owner. The repo used here is this one. The owner used is me.
