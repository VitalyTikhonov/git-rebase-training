rm -rf local local-someone-else\ remote\
rm my-* their-*
mkdir remote local

cd remote
git init --bare & REM to create a repository to be used as the central one

cd %PATH-Experiments%\local
git init
git config --local user.name ME & REM to make it look clearer when you run git log -8 at the end
git config --local user.email _
git remote add teamone %PATH-Experiments%\remote & REM linking a bare repo. If it would be non-bare, then ...\.git
echo "C1" >> my-master.md
git add .
git commit -m "C1"
git push -u teamone master & REM the branch appears only after the first commit, although the indicator (as well as the annotation next to the current folder address in the console) has been there since the very start
echo "C2" >> my-master.md & git add . & git commit -m "C2"
echo "C3" >> my-master.md & git add . & git commit -m "C3"

REM Now, someone else does more work that includes a merge, and pushes that work to the central server.
git clone %PATH-Experiments%\remote %PATH-Experiments%\local-someone-else
cd %PATH-Experiments%\local-someone-else
git config --local user.name THE_OTHER_TEAM
git config --local user.email _
git pull
git switch -c other-branch
git switch master
echo "C4" >> their-master.md & git add . & git commit -m "C4"
git switch other-branch
echo "C5" >> their-other-branch.md & git add . & git commit -m "C5"
git switch master
git merge other-branch --no-ff -m "C6"
git push

REM You fetch it and merge the new remote branch into your work
cd %PATH-Experiments%\local
git fetch
git merge --no-ff -m "C7"

REM Next, the person who pushed the merged work decides to go back and rebase their work instead; they do a git push --force to overwrite the history on the server.

cd %PATH-Experiments%\local-someone-else
git rebase other-branch
git commit --amend -m "C4' - rebased"
git branch -d other-branch & REM Not in the guide
git push --force
cd %PATH-Experiments%\local
git fetch


@REM ------------------------------------------------------------------------------------- BAD ALTERNATIVE \/
REM If you do a git pull, you'll create a merge commit which includes both lines of history.

@REM git pull
@REM git commit --amend -m "C8"

REM If you run a git log when your history looks like this, you'll see two commits that have the same author, date, and message, which will be confusing. Furthermore, if you push this history back up to the server, you'll reintroduce all those rebased commits to the central server, which can further confuse people. It's pretty safe to assume that the other developer doesn't want C4 and C6 to be in the history; that's why they rebased in the first place.
@REM ------------------------------------------------------------------------------ end of BAD ALTERNATIVE \/

@REM ---------------------------------------------------------------------------------- GOOD ALTERNATIVE 1 \/
@REM git rebase teamone/master
@REM git commit --amend -m "C3' - rebased"
@REM --------------------------------------------------------------------------- end of GOOD ALTERNATIVE 1 /\

@REM ---------------------------------------------------------------------------------- GOOD ALTERNATIVE 2 \/
git pull --rebase
@REM --------------------------------------------------------------------------- end of GOOD ALTERNATIVE 2 /\

git log --oneline --graph --decorate --all --remotes --branches HEAD
