#!/usr/bin/env bash

{ # this ensures the entire script is downloaded #
    tmuxconfig_has() {
        type "$1" >/dev/null 2>&1
    }

    tmuxconfig_echo() {
        command printf %s\\n "$*" 2>/dev/null
    }

    tmuxconfig_grep() {
        GREP_OPTIONS='' command grep "$@"
    }

    tmuxconfig_default_install_dir() {
        [ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.tmux" || printf %s "${XDG_CONFIG_HOME}/tmux"
    }

    tmuxconfig_install_dir() {
        if [ -n "$TMUXCONFIG_DIR" ]; then
            printf %s "${TMUXCONFIG_DIR}"
        else
            tmuxconfig_default_install_dir
        fi
    }

    tmuxconfig_latest_version() {
        tmuxconfig_echo "master"
    }

    install_tmuxconfig_from_git() {
        local TMUXCONFIG_VERSION
        TMUXCONFIG_VERSION="${TMUXCONFIG_INSTALL_VERSION:-$(tmuxconfig_latest_version)}"
        local TMUXCONFIG_SOURCE_URL
        TMUXCONFIG_SOURCE_URL="https://github.com/asapdotid/tmux-config.git"
        if [ -n "${TMUXCONFIG_INSTALL_VERSION:-}" ]; then
            # Check if version is an existing ref
            if command git ls-remote "$TMUXCONFIG_SOURCE_URL" "$TMUXCONFIG_VERSION" | tmuxconfig_grep -q "$TMUXCONFIG_VERSION"; then
                :
            # Check if version is an existing changeset
            elif ! tmuxconfig_download -o /dev/null "$TMUXCONFIG_SOURCE_URL"; then
                tmuxconfig_echo >&2 "Failed to find '$TMUXCONFIG_VERSION' version."
                exit 1
            fi
        fi

    }
}
