@REM https://git-scm.com/book/en/v2/Git-Branching-Rebasing
rm -rf local local-someone-else\ remote\
mkdir remote local

cd remote
git init --bare

cd ..\local
git init
git remote add origin D:/GOINTOIT/WEB-DEVELOPMENT/Projects-Training/Git/local-remote/remote & :: ссылка на bare-репозиторий. На non-bare - ...\.git
echo "c1" >> my-master.md
git add .
git commit -m "c1"
git push -u origin master & :: ветка появляется только после первого коммита, хотя указатель (и индикатор в адресе в терминале) существует сразу
echo "c2" >> my-master.md & git add . & git commit -m "c2"
echo "c3" >> my-master.md & git add . & git commit -m "c3"

@REM Now, someone else does more work that includes a merge, and pushes that work to the central server.
git clone D:/GOINTOIT/WEB-DEVELOPMENT/Projects-Training/Git/local-remote/remote ..\local-someone-else
cd ..\local-someone-else
git pull
git switch -c other-branch
git switch master
echo "c4" >> their-master.md & git add . & git commit -m "c4"
git switch other-branch
echo "c5" >> their-other-branch.md & git add . & git commit -m "c5"
git switch master
git merge other-branch --no-ff -m "c6"
git push

@REM You fetch it and merge the new remote branch into your work
cd ..\local
git fetch
git merge --no-ff -m "c7"

@REM Next, the person who pushed the merged work decides to go back and rebase their work instead; they do a git push --force to overwrite the history on the server.

