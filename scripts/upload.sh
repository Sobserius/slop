#!/usr/bin/env bash
# slop uploader - commit and push this dotfiles repo to GitHub, no thinking required.
#
#   ./scripts/upload.sh              # commit staged/unstaged changes and push
#   ./scripts/upload.sh "my message"  # same, with a message
#   ./scripts/upload.sh --dry-run    # show what would happen, touch nothing
#
# It stages the whole repo (dotfiles repos are meant to be edited in place),
# but never touches your wallpapers' ignore rules, and stops before pushing if
# there is nothing to push.
set -uo pipefail

_self="${BASH_SOURCE[0]}"
while [ -L "$_self" ]; do
    _dir="$(cd -P "$(dirname "$_self")" && pwd)"
    _self="$(readlink "$_self")"
    case "$_self" in
        /*) ;;
        *) _self="$_dir/$_self" ;;
    esac
done
REPO="$(cd -P "$(dirname "$_self")/.." && pwd)"
cd "$REPO" || exit 1

REMOTE="${SLOP_REMOTE:-origin}"
BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo main)"
DRY=0
case "${1:-}" in
    --dry-run | -n)
        DRY=1
        shift
        ;;
esac
MESSAGE="${1:-}"

c_ok() { printf '  \033[32mok\033[0m    %s\n' "$*"; }
c_warn() { printf '  \033[33mwarn\033[0m  %s\n' "$*"; }
c_err() { printf '  \033[31mfail\033[0m  %s\n' "$*"; }
step() { printf '\n\033[1m%s\033[0m\n' "$*"; }

# --- 1. sanity -----------------------------------------------------------------

step "repo"
c_ok "$REPO  (branch: $BRANCH)"

if ! git rev-parse --git-dir >/dev/null 2>&1; then
    c_err "not a git repository"
    exit 1
fi

if ! git remote get-url "$REMOTE" >/dev/null 2>&1; then
    c_err "no remote called '$REMOTE'"
    c_err "create one with:  git remote add $REMOTE https://github.com/Sobserius/slop.git"
    exit 1
fi
REMOTE_URL="$(git remote get-url "$REMOTE")"
c_ok "remote $REMOTE -> $REMOTE_URL"

# Git identity is required to commit; set it once and never think about it again.
if [ -z "$(git config user.name || true)" ] || [ -z "$(git config user.email || true)" ]; then
    step "identity"
    DEFAULT_NAME="${GITHUB_USER:-$(id -un)}"
    DEFAULT_MAIL="${GITHUB_USER:-$(id -un)}@users.noreply.github.com"
    read -r -p "  git user.name  [$DEFAULT_NAME]: " NAME
    read -r -p "  git user.email [$DEFAULT_MAIL]: " MAIL
    [ -n "${NAME:-}" ] || NAME="$DEFAULT_NAME"
    [ -n "${MAIL:-}" ] || MAIL="$DEFAULT_MAIL"
    git config user.name "$NAME"
    git config user.email "$MAIL"
    c_ok "saved user.name=$NAME user.email=$MAIL"
fi

# --- 2. stage ------------------------------------------------------------------

step "changes"
git add -A
if git diff --cached --quiet; then
    c_ok "working tree is clean - nothing to commit"
    CHANGES=0
else
    git diff --cached --stat | sed 's/^/  /'
    CHANGES=1
fi

# --- 3. commit ----------------------------------------------------------------

if [ "$CHANGES" = 1 ]; then
    step "commit"
    if [ -z "$MESSAGE" ]; then
        MESSAGE="$(git diff --cached --name-only | head -1 | sed 's|^|update: |')"
    fi
    c_ok "$MESSAGE"
    if [ "$DRY" = 1 ]; then
        c_warn "dry run - not committing"
    elif git commit -q -m "$MESSAGE"; then
        c_ok "committed $(git rev-parse --short HEAD)"
    else
        c_err "commit failed"
        exit 1
    fi
fi

# --- 4. push ------------------------------------------------------------------

step "push"
if [ "$DRY" = 1 ]; then
    c_warn "dry run - would run:  git push $REMOTE $BRANCH"
    printf '\n\033[32mdry run complete.\033[0m\n\n'
    exit 0
fi

git fetch -q "$REMOTE" "$BRANCH" 2>/dev/null || true
LOCAL="$(git rev-parse HEAD)"
REMOTE_SHA="$(git rev-parse "$REMOTE/$BRANCH" 2>/dev/null || true)"

if [ -n "$REMOTE_SHA" ] && [ "$(git rev-list --count "HEAD..$REMOTE_SHA")" -gt 0 ]; then
    # Local work is already committed at this point, so the tree is clean and a
    # rebase is safe. Do it here instead of making the user remember the order.
    step "rebase"
    c_warn "remote has commits you do not have - rebasing onto $REMOTE/$BRANCH"
    if git pull --rebase -q "$REMOTE" "$BRANCH" 2>&1; then
        c_ok "rebased onto $REMOTE/$BRANCH, now at $(git rev-parse --short HEAD)"
    else
        c_err "rebase hit a conflict, resolve it then run this again:"
        c_err "  git status              # see what is conflicted"
        c_err "  git rebase --continue   # after fixing each file"
        c_err "  git rebase --abort      # to back out and start over"
        exit 1
    fi
fi

BEHIND=0
if [ -n "$REMOTE_SHA" ]; then
    BEHIND="$(git rev-list --count "$REMOTE_SHA..HEAD")"
fi

if [ "$BEHIND" = 0 ] && [ -n "$REMOTE_SHA" ] && [ "$(git rev-parse HEAD)" = "$REMOTE_SHA" ]; then
    c_ok "already up to date on $REMOTE/$BRANCH"
    printf '\n\033[32mnothing to upload.\033[0m\n\n'
    exit 0
fi

# First push needs credentials. A Personal Access Token is the password; this
# script never stores it, it just passes it through and lets git cache it.
if [ -z "$REMOTE_SHA" ]; then
    c_warn "first push to $REMOTE/$BRANCH"
    c_warn "use a Personal Access Token as the password (not your account password)"
fi

if git push "$REMOTE" "$BRANCH"; then
    c_ok "pushed to $REMOTE/$BRANCH"
    printf '\n\033[32mup to date.\033[0m\n\n'
else
    c_err "push failed"
    cat <<'EOF'

  Most likely cause: no credentials yet. Pick one:

    A) HTTPS with a token (recommended)
       git remote set-url origin https://github.com/Sobserius/slop.git
       # create a token at https://github.com/settings/tokens (repo scope)
       # then re-run:  git push

    B) SSH
       ssh-keygen -t ed25519 -C "you@github"
       # print it:  cat ~/.ssh/id_ed25519.pub   -> add at https://github.com/settings/keys
       git remote set-url origin git@github.com:Sobserius/slop.git

EOF
    exit 1
fi