alias ga=fnGitAdd
alias gb=fnGitBranch
alias gba='git branch -a'
alias gd='git branch -D'
alias gbm=fnGitBranchMaster
alias go=fnGitCheckout
alias gol=fnGitCheckoutPull
alias gc=fnGitCommit
alias gch=fnGitCommitPush
alias gi='git diff'
alias gf='git fetch --all && gb'
alias gr=fnGitReset
alias gm=fnGitMerge
alias gn=fnGitPrune
alias gg=fnGitLog
alias ggv=fnGitLogVerbose
alias gl='git pull'
alias gh='git push'
alias ghf=fnGitPushForce
alias gs='git status -sb'
alias gt='git stash'
alias gta='git stash apply'
alias ge=fnGitRebase
alias gei=fnGitRebaseInteractive

fnCurrentGitBranch() {
  echo ${$(git symbolic-ref HEAD)##refs/heads/}
}

fnGitAdd() {
  git add -A .
}

fnGitPushForce() {
    echo ""
    read -q "CONFIRM?FORCE push $(fnCurrentGitBranch)? (y/N) "

    if [[ $CONFIRM == "y" ]] then
      git push --force
    fi
}

fnGitRebase() {
  git fetch origin
  if [[ $1 == "" ]]; then
    echo "rebasing to master by default"
    git rebase origin/master
  else
    git rebase origin/$1
  fi
}

fnGitRebaseInteractive() {
  if [[ $1 == "" ]]; then
    echo "rebasing from master by default"
    git rebase -i $(git merge-base $(fnCurrentGitBranch) master)
  else
    git rebase -i $(git merge-base $(fnCurrentGitBranch) $1)
  fi
}

# Does a hard reset with double confirmation if there are uncommitted changes.
fnGitReset() {
  uncommitted_changes=($(git status -s))

  if (( ${#uncommitted_changes[@]} == 0 )) then
    git reset --hard
  else
    echo ""
    echo "Uncommited chagnes:"
    git status -s

    echo ""
    read -q "CONFIRM?PERMANENTLY loose uncommitted changes above? (y/N) "

    if [[ $CONFIRM == "y" ]] then
      echo ""
      read -q "CONFIRM_AGAIN?You're aware there exists no black magic that can bring these back? (y/N) "
      echo ""

      if [[ $CONFIRM_AGAIN == "y" ]] then
        git reset --hard origin/$(fnCurrentGitBranch)
      fi
    fi
  fi

  unset uncommitted_changes
  unset CONFIRM
  unset CONFIRM_AGAIN
}

fnGitPrune() {
  # make sure we're in a git repo
  if [[ $(fnIsGitRepo) != "true" ]] then
    return false
  fi

  if [[ $1 != "" ]] then
    # save current branch
    original_branch=$(fnCurrentGitBranch);

    git checkout $1;
  fi

  # trim fetched to match remotes
  git pull --prune

  #                    +merged branches      -current       -specific
  branches_to_delete=$(git branch --merged | grep -v "\*" | egrep -v "master")

  # array from lines
  branches_to_delete=("${(f)branches_to_delete}")

  if [[ -z $branches_to_delete ]] then
    echo "All clean."
  else
    echo "\nBranches already merged into current branch:"
    # list branches
    for branch in $branches_to_delete; do
      echo "$branch"
    done

    echo ""
    read -q "CONFIRM?Delete ALL these? (y/N) "
    echo ""

    if [[ $CONFIRM == "y" ]]
      then
        # delete branches
        for branch in $branches_to_delete; do
          git branch -d ${branch// /}
        done

      else
        echo "\nCancelled"
    fi
  fi

  # if we switched branches, checkout the original
  if [[ -n $original_branch ]] then
    git checkout $original_branch
    unset original_branch
  fi

  unset branches_to_delete
}

fnGitBranch() {
  if (( $# == 0 )) then
    git branch --all
  else
    git pull
    git branch feature/$1
    git checkout feature/$1
    git push -u origin feature/$1
  fi
}

fnGitBranchMaster() {
  if (( $# == 0 )) then
    git branch -a
  else
    git checkout master
    git pull
    git branch feature/$1
    git checkout feature/$1
    git push -u origin feature/$1
  fi
}

fnGitCheckout() {
  # make sure we're in a git repo
  if [[ $(fnIsGitRepo) != "true" ]] then
    return false
  fi

  # get query from arg 1 or wild card
  if (( $# > 0 )) then
    go_query=$1
  else
    go_query="."
  fi

  # create branch array, only allow unique items
  # we'll add branches from HEAD and remotes, meaning possible dupes
  go_branches=()
  typeset -U go_branches

  # this fn is recursive
  # the first arg is always the query
  # the following are a list of branches matching the previous query
  # use args >2 as array of branch options (for recursive narrowing)
  if (( $# > 1 )) then
    set -A go_branches ${@:2}
  else
    # add branches in HEAD and on remotes
    for branch in $(git for-each-ref --shell --format='%(refname)' refs/{heads,remotes}); do

      # turn list of branches into something we can "git checkout"
      #
      # INPUT                           OUTPUT
      # 'refs/heads/master'             master
      # 'refs/remotes/origin/gh-pages'  origin gh-pages
      # 'refs/remotes/foo/feature/foo'  foo feature/bar

                                              # replace:
      branch=${branch//\'}                    #   single quotes
      branch=${branch/refs\/heads\/}          #   "refs/heads/"
      branch=${(S)branch/refs\/remotes\/*\/}  #   "refs/remotes/*/" (S) flag == shortest match

      # add scrubbed branch name to array
      go_branches+=($branch)

    done;
  fi

  # running recursively with no matching branches results in an endless loop
  # if there are no 'other' branches to switch to, notify and exit
  if (( ${#go_branches[@]} == 0 )) then
    echo "No other branches in HEAD or on remotes"
    return false
  fi

  go_counter=1
  go_matches=()
  for go_branch in $go_branches; do

    # if branch contains query
    if [[ $go_branch =~ $go_query ]] then;
      # add to array
      go_matches[$go_counter]=$go_branch

      # print index & name
      echo "$go_counter: $go_branch"

      # increment counter
      go_counter=$((go_counter+1))
    fi
  done;

  # 0 matches - rerun with no query, showing all options
  if (( ${#go_matches[@]} == 0 )) then
    fnGitCheckout
    return false
  fi

  # 1 match, save it
  if (( ${#go_matches[@]} == 1 )) then
    go_checkout=$go_matches[1]
  fi

  # >1 match, prompt for input
  if (( ${#go_matches[@]} > 1 )) then
    echo ""
    read "go_input?(query/#): "

    # if input, attempt select branch from array by index
    if [[ $go_input != "" ]] then
      go_checkout=$go_matches[$go_input]
    fi

    # if input did not result in a valid branch index
    # rerun with input as query against matches
    if [[ $go_checkout == "" ]] then
      fnGitCheckout $go_input $go_matches
      return false
    fi
  fi

  git checkout ${go_checkout}

  unset go_query
  unset go_branches
  unset go_counter
  unset go_branch
  unset go_matches
  unset go_checkout
  unset go_input
}

fnGitCheckoutPull() {
  fnGitCheckout $1
  git pull
}

fnGitCommit() {
  if (( $# == 0 )) then
    echo "commit what sucka?!"
  else
    fnGitAdd
    git commit -m "$1"
  fi
}

fnGitCommitPush() {
  if (( $# == 0 )) then
    echo "commit what sucka?!"
  else
    fnGitCommit $1
    git pull
    git push
  fi
}

fnGitMerge() {
  if (( $# == 0 )) then
    # save current branch
    original_branch=$(git branch | grep "* ");
    original_branch=${original_branch/"* "};

    # update master
    git checkout master
    git pull

    # merge into original branch
    git checkout $original_branch
    git merge master

    unset original_branch
  else
    git merge $1
  fi
}

fnGitLog() {
  if (( $# == 0 )) then
    git log --decorate --graph --oneline -n 10
  else
    git log --decorate --graph --oneline -n $1
  fi
}

fnGitLogVerbose() {
  if (( $# == 0 )) then
    git log --decorate --graph -n 10
  else
    git log --decorate --graph -n $1
  fi
}

##################################################
# Helper functions
##################################################

fnIsGitRepo() {
  git rev-parse --is-inside-work-tree
}
