#!/bin/bash
# dot-agents Sync Script
# 同步 Skills + Sessions + Memory 到 GitHub

set -e

DOT_AGENTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$HOME/.dot-agents-backup/$(date +%Y%m%d_%H%M%S)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

usage() {
    echo "Usage: $0 <push|pull|status>"
    echo ""
    echo "  push    Sync local -> GitHub"
    echo "  pull    Sync GitHub -> local"
    echo "  status  Show sync status"
}

do_push() {
    log_info "Starting push to GitHub..."

    # Backup first
    mkdir -p "$BACKUP_DIR"
    log_info "Backup directory: $BACKUP_DIR"

    # Backup current state
    if [ -d "$HOME/.hermes/skills" ]; then
        cp -r "$HOME/.hermes/skills" "$BACKUP_DIR/skills"
    fi
    if [ -f "$HOME/.hermes/state.db" ]; then
        cp "$HOME/.hermes/state.db" "$BACKUP_DIR/hermes_state.db"
    fi

    # Sync skills (bidirectional merge)
    log_info "Syncing skills..."
    rsync -av --delete \
        "$HOME/.hermes/skills/" \
        "$DOT_AGENTS_DIR/skills/"

    # Sync skills snapshot
    cp "$HOME/.hermes/.skills_prompt_snapshot.json" \
        "$DOT_AGENTS_DIR/skills/.skills_prompt_snapshot.json"

    # Sync sessions DB (copy, not merge)
    log_info "Syncing sessions..."
    cp "$HOME/.hermes/state.db" \
        "$DOT_AGENTS_DIR/sessions/hermes_state.db"

    # Sync configs
    log_info "Syncing configs..."
    rsync -av \
        "$HOME/.hermes/config.yaml" \
        "$DOT_AGENTS_DIR/config/hermes/config.yaml" 2>/dev/null || true
    rsync -av \
        "$HOME/.openclaw/openclaw.json" \
        "$DOT_AGENTS_DIR/config/openclaw/config.json" 2>/dev/null || true
    rsync -av \
        "$HOME/.claude/settings.json" \
        "$DOT_AGENTS_DIR/config/claudecode/settings.json" 2>/dev/null || true

    log_info "Push complete!"
    echo ""
    echo "Next steps:"
    echo "  cd $DOT_AGENTS_DIR"
    echo "  git add -A"
    echo "  git commit -m 'Sync $(date +%Y%m%d)'"
    echo "  git push"
}

do_pull() {
    log_info "Starting pull from GitHub..."

    # Sync skills back
    log_info "Syncing skills..."
    rsync -av --delete \
        "$DOT_AGENTS_DIR/skills/" \
        "$HOME/.hermes/skills/"

    # Sync skills snapshot
    cp "$DOT_AGENTS_DIR/skills/.skills_prompt_snapshot.json" \
        "$HOME/.hermes/.skills_prompt_snapshot.json" 2>/dev/null || true

    # Sync sessions DB
    log_info "Syncing sessions..."
    cp "$DOT_AGENTS_DIR/sessions/hermes_state.db" \
        "$HOME/.hermes/state.db"

    # Sync configs
    log_info "Syncing configs..."
    rsync -av \
        "$DOT_AGENTS_DIR/config/hermes/config.yaml" \
        "$HOME/.hermes/config.yaml" 2>/dev/null || true
    rsync -av \
        "$DOT_AGENTS_DIR/config/openclaw/config.json" \
        "$HOME/.openclaw/openclaw.json" 2>/dev/null || true
    rsync -av \
        "$DOT_AGENTS_DIR/config/claudecode/settings.json" \
        "$HOME/.claude/settings.json" 2>/dev/null || true

    log_info "Pull complete!"
}

do_status() {
    echo "=== dot-agents Sync Status ==="
    echo ""

    echo "Local Skills:"
    echo "  Count: $(ls -1 $HOME/.hermes/skills/ 2>/dev/null | wc -l | tr -d ' ')"
    echo "  Last modified: $(ls -ldt $HOME/.hermes/skills/*/ 2>/dev/null | head -1 | awk '{print $6, $7, $8}')"
    echo ""

    echo "Repo Skills:"
    echo "  Count: $(ls -1 $DOT_AGENTS_DIR/skills/ 2>/dev/null | wc -l | tr -d ' ')"
    echo "  Last modified: $(ls -ldt $DOT_AGENTS_DIR/skills/*/ 2>/dev/null | head -1 | awk '{print $6, $7, $8}')"
    echo ""

    echo "Sessions DB:"
    echo "  Local: $(ls -lh $HOME/.hermes/state.db 2>/dev/null | awk '{print $5, $6, $7, $8}')"
    echo "  Repo:  $(ls -lh $DOT_AGENTS_DIR/sessions/hermes_state.db 2>/dev/null | awk '{print $5, $6, $7, $8}')"
    echo ""

    echo "Git status:"
    cd "$DOT_AGENTS_DIR"
    if [ -d .git ]; then
        git status --short 2>/dev/null | head -10
    else
        echo "  Not a git repo (run: cd $DOT_AGENTS_DIR && git init)"
    fi
}

# Main
case "${1:-}" in
    push)
        do_push
        ;;
    pull)
        do_pull
        ;;
    status)
        do_status
        ;;
    *)
        usage
        exit 1
        ;;
esac
