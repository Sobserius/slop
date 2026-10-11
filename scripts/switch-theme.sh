#!/usr/bin/env bash
# slop theme switcher - dark (Mocha) <-> light (Latte).
#
#   switch-theme [dark|light|toggle|status]
#
# Everything themed lives in ~/slop/<theme>/; this script only repoints symlinks
# in ~/.config and reloads the affected daemons. Edits inside ~/slop apply
# immediately - no reinstall step.
set -uo pipefail

# --- locate the repo, following however many symlinks we were invoked through ---
_self="${BASH_SOURCE[0]}"
while [ -L "$_self" ]; do
    _dir="$(cd -P "$(dirname "$_self")" && pwd)"
    _self="$(readlink "$_self")"
    case "$_self" in
        /*) ;;
        *) _self="$_dir/$_self" ;;
    esac
done
SCRIPT_PATH="$(cd -P "$(dirname "$_self")" && pwd)/$(basename "$_self")"
REPO="${SLOP_REPO:-$(cd -P "$(dirname "$SCRIPT_PATH")/.." && pwd)}"

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/slop"
STATE_FILE="$CACHE_DIR/theme"
BIN_DIR="$HOME/.local/bin"

die() { printf 'switch-theme: %s\n' "$*" >&2; exit 1; }
info() { printf '  %s\n' "$*"; }

active_theme() {
    local t
    t="$(cat "$STATE_FILE" 2>/dev/null || true)"
    case "$t" in
        dark | light) printf '%s\n' "$t" ;;
        *) printf 'dark\n' ;;
    esac
}

# --- helpers -------------------------------------------------------------------

# link <target> <path>: idempotently point <path> at <target>.
link() {
    local target="$1" path="$2" dir backup n
    mkdir -p "$(dirname "$path")"
    if [ -L "$path" ]; then
        if [ "$(readlink -f "$path" 2>/dev/null)" = "$(readlink -f "$target")" ]; then
            return 0
        fi
        rm -f "$path"
    elif [ -e "$path" ]; then
        dir="$(dirname "$path")"
        backup="$path.slop-backup"
        n=1
        while [ -e "$backup" ]; do
            backup="$path.slop-backup.$n"
            n=$((n + 1))
        done
        mv "$path" "$backup"
        info "backed up $path -> $(basename "$backup")"
    fi
    ln -s "$target" "$path"
}

have() { command -v "$1" >/dev/null 2>&1; }

sway_available() { have swaymsg && [ -n "${WAYLAND_DISPLAY:-}" ] && swaymsg -t get_outputs >/dev/null 2>&1; }

# --- argument ------------------------------------------------------------------

action="${1:-toggle}"
case "$action" in
    dark | light) requested="$action" ;;
    toggle)
        if [ "$(active_theme)" = dark ]; then requested=light; else requested=dark; fi
        ;;
    status)
        current="$(active_theme)"
        # shellcheck disable=SC1090
        . "$REPO/$current/theme.env" 2>/dev/null || true
        printf 'slop theme: %s  (%s)\n' "$current" "${SLOP_LABEL:-?}"
        printf 'repo:       %s\n' "$REPO"
        printf 'bar button: THEME, right of PWR - click to toggle\n'
        exit 0
        ;;
    -h | --help | help)
        sed -n '2,9p' "$SCRIPT_PATH" | sed 's/^# \{0,1\}//'
        exit 0
        ;;
    *) die "unknown argument '$action' (expected: dark, light, toggle, status)" ;;
esac

[ -f "$REPO/$requested/theme.env" ] || die "missing $REPO/$requested/theme.env - is $REPO a slop checkout?"

# shellcheck disable=SC1091
. "$REPO/$requested/theme.env"

current="$(active_theme)"
if [ "$current" = "$requested" ]; then
    info "already on $requested - re-applying anyway"
fi

# --- wire the symlinks ---------------------------------------------------------

link "$REPO/shared/waybar/config" "$CONFIG_DIR/waybar/config"
link "$REPO/$requested/waybar/style.css" "$CONFIG_DIR/waybar/style.css"
link "$REPO/shared/waybar/scripts" "$CONFIG_DIR/waybar/scripts"

link "$REPO/$requested/swaylock/config" "$CONFIG_DIR/swaylock/config"
link "$REPO/$requested/mako/config" "$CONFIG_DIR/mako/config"
link "$REPO/$requested/fuzzel/fuzzel.ini" "$CONFIG_DIR/fuzzel/fuzzel.ini"

link "$REPO/shared/kitty/kitty.conf" "$CONFIG_DIR/kitty/kitty.conf"
link "$REPO/$requested/kitty/theme.conf" "$CONFIG_DIR/kitty/theme.conf"

link "$REPO/shared/sway/config" "$CONFIG_DIR/sway/config"
link "$REPO/$requested/sway/theme.conf" "$CONFIG_DIR/sway/theme.conf"
link "$REPO/shared/sway/scripts" "$CONFIG_DIR/sway/scripts"

link "$SCRIPT_PATH" "$BIN_DIR/switch-theme"

# --- wallpaper: dark -> wallpaper.png, light -> lallpaper.png --------------------

mkdir -p "$CACHE_DIR"
printf '%s\n' "$requested" >"$STATE_FILE"

wallpaper_src="$REPO/$requested/$SLOP_WALLPAPER"
wallpaper_dst="$HOME/$SLOP_WALLPAPER"
if [ -f "$wallpaper_src" ]; then
    if [ ! -f "$wallpaper_dst" ] || ! cmp -s "$wallpaper_src" "$wallpaper_dst"; then
        cp -f "$wallpaper_src" "$wallpaper_dst"
    fi
else
    info "no $SLOP_WALLPAPER in $REPO/$requested - keeping $wallpaper_dst"
fi

# --- GTK / desktop ------------------------------------------------------------

if have gsettings; then
    gsettings set org.gnome.desktop.interface icon-theme "$SLOP_ICON_THEME" 2>/dev/null ||
        info "gsettings: icon-theme not set (is $SLOP_ICON_THEME installed?)"
    gsettings set org.gnome.desktop.interface color-scheme "$SLOP_COLOR_SCHEME" 2>/dev/null ||
        info "gsettings: color-scheme not set"
fi

# --- reload running services ---------------------------------------------------

# Sway owns the wallpaper itself (`output ... bg`), so it restarts swaybg on its
# own and there is never a second copy fighting for the screen. Anything that
# does not understand swaymsg still gets one from the fallback below.
if sway_available; then
    if [ -f "$wallpaper_dst" ]; then
        swaymsg output '*' bg "$wallpaper_dst" fill >/dev/null 2>&1 ||
            info "could not set the wallpaper on all outputs"
    fi
    if have sway && sway --validate -c "$CONFIG_DIR/sway/config" >/dev/null 2>&1; then
        swaymsg reload >/dev/null 2>&1 && info "sway reloaded"
    else
        info "sway config failed validation - NOT reloading (check $CONFIG_DIR/sway/config)"
    fi
elif [ -f "$wallpaper_dst" ] && have swaybg && [ -n "${WAYLAND_DISPLAY:-}" ]; then
    pkill -x swaybg 2>/dev/null
    setsid swaybg -o '*' -i "$wallpaper_dst" -m fill >/dev/null 2>&1 &
    info "wallpaper set (no sway running, using swaybg directly)"
fi

if pgrep -x waybar >/dev/null 2>&1; then
    pkill -USR2 waybar && info "waybar reloaded"
fi

if have makoctl; then
    makoctl reload >/dev/null 2>&1 && info "mako reloaded"
fi

# --- report --------------------------------------------------------------------

printf 'slop theme -> %s  (%s)\n' "$requested" "$SLOP_LABEL"
printf '  wallpaper: %s\n' "$wallpaper_dst"