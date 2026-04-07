#!/usr/bin/env bash
# Bash completion for TerraformMissions
_terraformissions_completions() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local commands="check check-dry watch hint solution guide debrief plan validate init reset status skip quit reset-progress help"
  COMPREPLY=( $(compgen -W "$commands" -- "$cur") )
}
complete -F _terraformissions_completions terraformissions
complete -F _terraformissions_completions ./play.sh
