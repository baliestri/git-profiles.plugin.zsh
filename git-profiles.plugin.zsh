# Copyright (c) Bruno Sales <me@baliestri.dev>. Licensed under the MIT License.
# See the LICENSE file in the project root for full license information.

#!/usr/bin/env zsh

## File to store the profiles
export GIT_PROFILES_FILE="${GIT_PROFILES_FILE:-${HOME}/.config/git/profiles}"
export GIT_PROFILES_FILE_FALLBACK="${HOME}/.git-profiles"

function __git_profiles_hook() {
  ## Check if git is installed
  if (( ! $+commands[git] )); then
    return 1
  fi

  ## Check if the file exists
  if [[ ! -f "${GIT_PROFILES_FILE}" ]]; then
    export GIT_PROFILES_FILE="${GIT_PROFILES_FILE_FALLBACK}"
  fi

  ## Load all stored profiles
  local profiles=($(grep -o '\[profile [^]]*\]' ${GIT_PROFILES_FILE} | tr -d '[]" ' | sed 's/profile//g' | tr '\n' ' '))

  local -A profiles_paths=()
  local -A profiles_configs=()

  ## Iterate over all profiles to get the name, email, signingkey and path
  for profile in ${profiles}; do
    while read -r key value; do
      case "${key}" in
        name)
          profile_name="${value}"
          ;;
        email)
          profile_email="${value}"
          ;;
        signingkey)
          profile_signingkey="${value}"
          ;;
        path)
          profile_path="${value}"
          ;;
      esac
    done < <(awk -F ' = ' '/^\[profile/{p=0} /^\[profile "[^"]*'"${profile}"'"/{p=1} p {gsub(/"/, "", $2); print $1,$2}' ${GIT_PROFILES_FILE})

    profiles_paths[${profile}]="${profile_path}"

    profiles_configs[${profile}.name]="${profile_name}"
    profiles_configs[${profile}.email]="${profile_email}"

    if [[ -n "${profile_signingkey}" ]]; then
      profiles_configs[${profile}.signingkey]="${profile_signingkey}"
    fi
  done

  ## Get the current directory
  local current_dir=$(pwd)

  ## Check if the current directory is in one of the profiles paths
  for profile in ${(k)profiles_paths}; do
    if [[ "${current_dir}" =~ "${profiles_paths[${profile}]}" ]]; then
      local current_profile="${profile}"
      break
    fi
  done

  ## If the current directory is not in any profile path, use the default profile
  if [[ -z "${current_profile}" ]]; then
    local current_profile="default"
  fi

  ## Define the current profile name and email
  local current_profile_name="${profiles_configs[${current_profile}.name]}"
  local current_profile_email="${profiles_configs[${current_profile}.email]}"

  ## Set the current profile name and email
  git config --global user.name "${current_profile_name}"
  git config --global user.email "${current_profile_email}"

  ## Set the current profile signingkey if it exists
  if [[ -n "${profiles_configs[${current_profile}.signingkey]}" ]]; then
    local current_profile_signingkey="${profiles_configs[${current_profile}.signingkey]}"

    git config --global user.signingkey "${current_profile_signingkey}"
  fi
}

add-zsh-hook chpwd __git_profiles_hook
