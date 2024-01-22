alias cdgr='cd `git rev-parse --show-toplevel`'
alias ga=fnGitAdd
alias gap='git add -p'
alias gac='fnGitAdd && fnGitCommit'
alias gb=fnGitBranch
alias gba='git branch -a'
alias gd='git branch -D'
alias gbm=fnGitBranchMain
alias go=fnGitCheckout
alias gol=fnGitCheckoutPull
alias gc=fnGitCommit
alias gch=fnGitCommitPush
alias gach=fnGitAddCommitPush
alias gcn=fnGitCommitNoVerify
alias gchn=fnGitCommitPushNoVerify
alias gachn=fnGitAddCommitPushNoVerify
alias guh="git log --branches --not --remotes --no-walk --decorate --oneline"
alias gca='git commit --amend'
alias gcam='git commit --amend --message'
alias gcan='git commit --amend --no-edit'
alias gaca='git add -A && git commit --amend'
alias gacan='git add -A && git commit --amend --no-edit'
alias gcp='git cherry-pick'
alias gi='git diff'
alias giw='git diff --word-diff'
alias gf='git fetch --all'
alias gr=fnGitReset
alias gm=fnGitMerge
alias gn=fnGitPrune
alias gg=fnGitLog
alias ggv=fnGitLogVerbose
alias gl='git pull'
alias gln='git pull && fnGitPrune'
alias gh='git push'
alias ghf=fnGitPushForce
alias gpr=fnGitPullRequest
alias gs='git status -sb'
alias gt='git stash save'
alias gta='git stash apply'
alias gu='git reset HEAD~'
alias ge=fnGitRebase
alias gea='git rebase --abort'
alias gec='git rebase --continue'
alias ges='git rebase --skip'
alias gaec='git add -A && git rebase --continue'
alias gei=fnGitRebaseInteractive
alias clean-ignored=fnCleanGitIgnored
alias git-changes-with=fnGitChangesWith
alias git-contributors=fnGitContributors

fnGitContributors() {
  git log --pretty=format:'%an' --date=format:'%Y-%m-%d' --follow $1 | sort | uniq -c | sort
}

fnGitChangesWith() {
  git log --pretty="%H" --follow $1 | xargs -I {} git diff-tree --no-commit-id --name-only -r {} | sort | uniq -c | sort -n
}

fnGitRemoteName() {
  echo $(git remote show)
}

fnGitTrunkName() {
  # First check locally
  if [[ ! -z $(git branch --list "master") ]]; then
    echo "master"
  else
    if [[ ! -z $(git branch --list "main") ]]; then
      echo "main"
    else

      # ! WARNING SLOW ! :(
      # Finally check remote
      if [[ ! -z $(git ls-remote --heads $(fnGitRemoteName) "master") ]]; then
        echo "master"
      else
        if [[ ! -z $(git ls-remote --heads $(fnGitRemoteName) "main") ]]; then
          echo "main"
        else
          echo "fnGitTrunkName could not resolve trunk name"
          exit 1
        fi
      fi
    fi
  fi
}

fnGitPullRequest() {
  if [[ $1 == "" ]]; then
    local last_commit_message=$(git log -1 --pretty=%B)
    local title=${last_commit_message//'\n'}
  else
    local title=$1
  fi

  if [[ $2 != "" ]]; then
    local base_branch=$2
  fi

  open $(hub pull-request -m "$title" -b "$base_branch")
}

fnCleanGitIgnored() {
  if [[ ! -e ".gitignore" ]] then
    echo "Yo, there's no .gitignore here."
  else
    while read line; do
      if [[ ! -e "$line" ]] && continue

      echo ""
      echo "rm -rf $line"
      read -q "CONFIRM?y/N: "
      echo ""
      [[ $CONFIRM == "y" ]] && rm -rf $line
    done < .gitignore

    echo ""
    echo "Done"
  fi
}

fnGitCurrentBranch() {
  echo $(git symbolic-ref HEAD --short)
}

fnGitUpstream() {
  echo $(git rev-parse --abbrev-ref --symbolic-full-name @{u})
}

fnGitAdd() {
  if [[ $1 == "" ]]; then
    git add -A
  else
    git add $*
  fi
}

fnGitPushForce() {
  echo ""
  read -q "CONFIRM?FORCE push $(fnGitCurrentBranch)? (y/N) "
  echo ""

  if [[ $CONFIRM == "y" ]] then
    git push --force
  fi
}

fnGitRebase() {
  echo ""
  echo "  git fetch $(fnGitRemoteName) $(fnGitTrunkName)"
  echo "  git rebase $(fnGitRemoteName)/$(fnGitTrunkName)"
  echo ""
  read -q "CONFIRM?Go? (y/N) "
  echo ""

  if [[ $CONFIRM != "y" ]]; then
    return false
  fi

  git fetch $(fnGitRemoteName) $(fnGitTrunkName)
  git rebase $(fnGitRemoteName)/$(fnGitTrunkName)
}

fnGitRebaseInteractive() {
  if [[ $1 == "" ]]; then
    echo "rebasing from ${fnGitTrunkName} by default"
    git fetch $(fnGitRemoteName)
    git rebase -i $(git merge-base $(fnGitCurrentBranch) $(fnGitRemoteName)/$(fnGitTrunkName))
  else
    git fetch -a
    git rebase -i $(git merge-base $(fnGitCurrentBranch) $1)
  fi
}

# Does a hard reset with double confirmation if there are uncommitted changes.
fnGitReset() {
  uncommitted_changes=($(git status -s))

  if (( ${#uncommitted_changes[@]} == 0 )) then
    git reset --hard $(fnGitUpstream)
  else
    echo ""
    echo "Uncommited chagnes:"
    git status -s

    echo ""
    read -q "CONFIRM?PERMANENTLY lose uncommitted changes above? (y/N) "

    if [[ $CONFIRM == "y" ]] then
      echo ""
      read -q "CONFIRM_AGAIN?You're aware there exists no black magic that can bring these back? (y/N) "
      echo ""

      if [[ $CONFIRM_AGAIN == "y" ]] then
        git reset --hard $(fnGitUpstream)
        # also remove untracked files
        git clean -df
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

  # save current branch
  original_branch=$(fnGitCurrentBranch);

  git checkout $(fnGitTrunkName)

  # trim fetched to match remotes
  git pull --prune

  # We just pruned remote tracking branches, get a list of local branches are missing remotes
  #
  # get verbose branch info
  # remove the current branch
  # filter by branches with a remote tracking branch that does not exist on remote
  # print only their branch names
  branches_to_delete=$(git branch -vv | grep -v "\*" | grep ": gone]" | awk '{print $1}')

  # array from lines
  branches_to_delete=("${(f)branches_to_delete}")

  if [[ -z $branches_to_delete ]] then
    echo "All clean."
  else
    echo "\nBranches with missing remote tracking branches:"
    # list branches
    for branch in $branches_to_delete; do
      echo "- $branch"
    done

    echo ""
    read -q "CONFIRM?Delete ALL these? (y/N) "
    echo ""

    if [[ $CONFIRM == "y" ]]
      then
        # delete branches
        for branch in $branches_to_delete; do
          git branch -D ${branch// /}
        done

      else
        echo "\nCancelled"
    fi
  fi

  git checkout $original_branch
  unset original_branch

  unset branches_to_delete
}

fnGitBranch() {
  if (( $# == 0 )) then
    git branch
  else
    git checkout -b $1
    git push -u $(fnGitRemoteName) $1
  fi
}

fnGitBranchMain() {
  if (( $# == 0 )) then
    git branch
  else
    git checkout $(fnGitTrunkName)
    git pull
    git checkout -b $1
    git push -u $(fnGitRemoteName) $1
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
      # 'refs/heads/main'               main
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
    git commit -m "$1"
  fi
}

fnGitCommitNoVerify() {
  if (( $# == 0 )) then
    echo "commit what sucka?!"
  else
    git commit -n -m "$1"
  fi
}

fnGitAddCommitPush() {
  if (( $# == 0 )) then
    echo "commit message?"
  else
    fnGitAdd
    fnGitCommitPush $1
  fi
}

fnGitAddCommitPushNoVerify() {
  if (( $# == 0 )) then
    echo "commit message?"
  else
    fnGitAdd
    fnGitCommitPushNoVreify $1
  fi
}

fnGitCommitPush() {
  if (( $# == 0 )) then
    echo "commit what sucka?!"
  else
    fnGitCommit $1
    git push
  fi
}

fnGitCommitPushNoVreify() {
  if (( $# == 0 )) then
    echo "commit what sucka?!"
  else
    fnGitCommitNoVerify $1
    git push
  fi
}

fnGitMerge() {
  local branch=${1:-$(fnGitTrunkName)}

  echo "fetching: $(fnGitRemoteName) $branch"
  git fetch $(fnGitRemoteName) $branch
  echo "merging: $(fnGitRemoteName)/$branch"
  git merge $(fnGitRemoteName)/$branch
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
