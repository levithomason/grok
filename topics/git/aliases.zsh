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
alias gop='git checkout -'
alias gc=fnGitCommit
alias gcp=fnGitCommitPush
alias gacp=fnGitAddCommitPush
alias gcn=fnGitCommitNoVerify
alias gacn=fnGitAddCommitNoVerify
alias gcpn=fnGitCommitPushNoVerify
alias gacpn=fnGitAddCommitPushNoVerify
alias gup="git log --branches --not --remotes --no-walk --decorate --oneline"
alias gca='git commit --amend'
alias gcam='git commit --amend --message'
alias gcan='git commit --amend --no-edit'
alias gaca='git add -A && git commit --amend'
alias gacan='git add -A && git commit --amend --no-edit'
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
alias gp='git push'
alias gpf=fnGitPushForce
alias gpr=fnGitPullRequest
alias gs='git status --short --find-renames --untracked-files'
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
  # Get the remote for the current branch
  local remote=$(git config --get branch.$(fnGitCurrentBranch).remote)

  # If there is no remote for the current branch, default to "origin"
  if [[ -z $remote ]]; then
    echo "origin"
  else
    echo $remote
  fi
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
  local last_commit_message=$(git log -1 --pretty=%B)

  if [[ $1 == "" ]]; then
    local title=${last_commit_message//'\n'}
  else
    local title="$1"
  fi

  if [[ $2 == "" ]]; then
    local body=${last_commit_message//'\n'}
  else
    local body="$2"
  fi

  if [[ $3 != "" ]]; then
    local base="$3"
  else
    local base=$(fnGitTrunkName)
  fi

  gh pr create --web --title "$title" --body "$body" --base "$base"
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
    echo "rebasing from $(fnGitTrunkName) by default"
    git fetch $(fnGitRemoteName)
    git rebase -i $(git merge-base $(fnGitCurrentBranch) $(fnGitRemoteName)/$(fnGitTrunkName))
  else
    git fetch -a
    git rebase -i $(git merge-base $(fnGitCurrentBranch) $1)
  fi
}

# Does a hard reset with double confirmation if there are uncommitted changes.
fnGitReset() {
  local has_changes=$(git status --porcelain)

  if [[ -z "$has_changes" ]] then
    git reset --hard $(fnGitUpstream)
  else
    echo ""
    echo "Uncommitted changes:"
    git status -s

    echo ""
    local CONFIRM
    read -q "CONFIRM?PERMANENTLY lose uncommitted changes above? (y/N) "

    if [[ $CONFIRM == "y" ]] then
      echo ""
      local CONFIRM_AGAIN
      read -q "CONFIRM_AGAIN?You're aware there exists no black magic that can bring these back? (y/N) "
      echo ""

      if [[ $CONFIRM_AGAIN == "y" ]] then
        git reset --hard $(fnGitUpstream)
      fi
    fi
  fi
}

# Remove worktrees abandoned by a dead process.
#
# `git worktree prune` only clears admin entries whose directory has vanished;
# it leaves behind worktrees that still exist on disk but whose owning process
# is gone. Claude Code agent worktrees (under .claude/worktrees/, each carrying
# a full node_modules) are the usual offenders: they lock the worktree with the
# agent's pid and never unlock if that agent is killed. We remove ONLY worktrees
# locked by a pid that is no longer alive — a live agent keeps an alive pid, and
# worktrees you create by hand are unlocked, so neither is ever touched.
fnGitPruneWorktrees() {
  # NOTE: do NOT name a local `path` — in zsh it is the array tied to $PATH,
  # so shadowing it empties PATH inside this function and breaks every command.
  local to_remove=()
  local line wt gitdir_line admindir reason pid kerr branch dirty label CONFIRM
  local first=1

  while IFS= read -r line; do
    [[ $line == worktree\ * ]] || continue
    wt=${line#worktree }

    # skip the main worktree (always the first record)
    if (( first )); then first=0; continue; fi

    # a linked worktree's .git is a file pointing at its admin dir
    [[ -f "$wt/.git" ]] || continue
    gitdir_line=$(< "$wt/.git")
    admindir=${gitdir_line#gitdir: }

    # consider only worktrees locked by a dead pid. anchor the `pid` token so a
    # reason like "stupid 4242" can't be misread as pid 4242.
    [[ -f "$admindir/locked" ]] || continue
    reason=$(< "$admindir/locked")
    [[ $reason =~ '(^|[^[:alnum:]])pid ([0-9]+)' ]] || continue
    pid=$match[2]

    # keep the worktree if its owner is still alive. `kill -0` success = alive;
    # on failure distinguish "no such process" (dead -> candidate) from
    # "operation not permitted" (alive, owned by another user -> keep). fail
    # closed: only a confirmed-dead pid makes a worktree a removal candidate.
    if kerr=$(kill -0 $pid 2>&1); then continue; fi
    [[ $kerr == *permitted* ]] && continue

    to_remove+=("$wt")
  done < <(git worktree list --porcelain)

  (( ${#to_remove[@]} > 0 )) || return 0

  echo "\nWorktrees abandoned by a dead process:"
  for wt in "${to_remove[@]}"; do
    branch=$(git -C "$wt" symbolic-ref --short -q HEAD || echo "detached")
    dirty=$(git -C "$wt" status --porcelain 2>/dev/null | grep -c .)
    label="- $wt ($branch"
    (( dirty > 0 )) && label+=", $dirty UNCOMMITTED"
    echo "$label)"
  done

  echo ""
  read -q "CONFIRM?Remove ALL these worktrees? (y/N) "
  echo ""

  if [[ $CONFIRM == "y" ]] then
    for wt in "${to_remove[@]}"; do
      git worktree unlock "$wt" 2>/dev/null
      git worktree remove --force "$wt" && echo "removed $wt"
    done
  else
    echo "\nCancelled"
  fi
}

fnGitPrune() {
  # make sure we're in a git repo
  if [[ $(fnIsGitRepo) != "true" ]] then
    return false
  fi

  # prune stale worktree entries (directories no longer on disk)
  # this un-marks branches with + so they become eligible for deletion below
  git worktree prune

  # remove worktrees abandoned by a dead process (stale lock pid), which
  # `git worktree prune` leaves behind; frees their branches for deletion below
  fnGitPruneWorktrees

  # prune remote tracking branches without switching away from current branch
  git fetch --prune

  # --- classify every deletable branch by whether its work survives deletion ---
  #
  # A branch is safe to delete only when its commits are preserved elsewhere. The
  # ONLY unsafe case is commits that live on no remote AND were never merged — the
  # trap now that AI creates branches that don't follow the "always pushed" rule.
  # Each branch gets one verdict so the confirm is fearless:
  #
  #   MERGED - its PR merged, or it is already in the trunk. Safe. (A squash merge
  #            rewrites your commits into one trunk commit, so they sit on no remote
  #            branch — only the PR-merged / in-trunk check can see this. Needs gh.)
  #   PUSHED - every commit is reachable from some remote; the local ref is
  #            disposable (the classic rule). Safe.
  #   UNIQUE - commits on no remote, not merged. Real work, lost with the branch.
  #
  # Left untouched: the trunk, the current branch (*), worktree-held branches (+),
  # any branch with a live remote and no merge (active work), and any branch whose
  # name has an OPEN PR (names get reused across a merged and a later open PR).

  local trunk remote_trunk merged_prs open_prs remote_branches
  trunk=$(fnGitTrunkName)
  remote_trunk="$(fnGitRemoteName)/$trunk"
  remote_branches=$(git branch -r 2>/dev/null | sed 's/^ *//' | grep -v 'HEAD' | sed 's|^origin/||')

  # PR state, fetched once. Empty when gh is absent or this is not a GitHub repo;
  # then MERGED falls back to the in-trunk (ancestry) check only, so a squash-merged
  # branch lands in UNIQUE — surfaced, never silently deleted. Fails safe.
  if command -v gh >/dev/null 2>&1; then
    merged_prs=$(gh pr list --state merged --limit 4000 --json headRefName --jq '.[].headRefName' 2>/dev/null)
    open_prs=$(gh pr list --state open --limit 4000 --json headRefName --jq '.[].headRefName' 2>/dev/null)
  fi

  # local branches except the current one (*) and worktree-held ones (+)
  local candidates
  candidates=$(git branch -vv | grep -v '^[*+]' | awk '{print $1}')

  local merged_list=() pushed_list=() unique_list=()
  local branch unpushed
  while IFS= read -r branch; do
    [[ -z "$branch" || "$branch" == "$trunk" ]] && continue
    # live PR on this name -> active work, never delete
    echo "$open_prs" | grep -qxF "$branch" && continue
    # merged: PR merged, or already contained in the trunk
    if { [[ -n "$merged_prs" ]] && echo "$merged_prs" | grep -qxF "$branch"; } \
       || git merge-base --is-ancestor "$branch" "$remote_trunk" 2>/dev/null; then
      merged_list+=("$branch")
      continue
    fi
    # not merged: leave branches that still have a live remote (active work)
    echo "$remote_branches" | grep -qxF "$branch" && continue
    # remote gone/absent: safe only if every commit lives on some remote ref.
    # `--not --remotes` fails safe (counts everything when there are no remotes).
    unpushed=$(git rev-list --count "$branch" --not --remotes 2>/dev/null)
    if (( unpushed > 0 )); then
      unique_list+=("$branch:$unpushed")
    else
      pushed_list+=("$branch")
    fi
  done <<< "$candidates"

  # SAFE: merged + pushed, one confirm — the fearless "yes"
  local safe=("${merged_list[@]}" "${pushed_list[@]}")
  if (( ${#safe[@]} > 0 )) then
    echo "\nSafe to delete — work is preserved elsewhere:"
    for branch in "${merged_list[@]}"; do echo "  MERGED  $branch"; done
    for branch in "${pushed_list[@]}"; do echo "  PUSHED  $branch"; done

    echo ""
    read -q "CONFIRM?Delete all ${#safe[@]} safe branches? (y/N) "
    echo ""

    if [[ $CONFIRM == "y" ]] then
      for branch in "${safe[@]}"; do
        git branch -D ${branch// /}
      done
    else
      echo "\nCancelled"
    fi
  fi

  # UNSAFE: unique work, on no remote and never merged — itemized, scarier confirm
  if (( ${#unique_list[@]} > 0 )) then
    echo "\n⚠️  UNIQUE — commits on no remote, not merged (lost forever if deleted):"
    for entry in "${unique_list[@]}"; do
      echo "  ${entry%:*} (${entry##*:} unpushed)"
    done

    echo ""
    read -q "CONFIRM?Delete these UNMERGED, UNPUSHED branches? (y/N) "
    echo ""

    if [[ $CONFIRM == "y" ]] then
      for entry in "${unique_list[@]}"; do
        branch=${entry%:*}
        git branch -D ${branch// /}
      done
    else
      echo "\nCancelled"
    fi
  fi

  if (( ${#safe[@]} == 0 && ${#unique_list[@]} == 0 )) then
    echo "No deletable branches."
  fi
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

    # Validate input as a number and within range
    if [[ $go_input =~ ^[0-9]+$ ]] && (( go_input > 0 && go_input <= ${#go_matches[@]} )); then
      go_checkout=${go_matches[$go_input]}
    else
      # If input is not a valid number, treat it as a new query
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

fnGitAddCommitNoVerify() {
  fnGitAdd
  fnGitCommitNoVerify $1
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
    fnGitCommitPushNoVerify $1
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

fnGitCommitPushNoVerify() {
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
