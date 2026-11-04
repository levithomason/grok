# Load missing identity keys without clearing the connected agent.
() {
  local identities agent_status agent_settings public_key key key_details fingerprint
  local -a key_fields
  local result=0

  identities=$(ssh-add -l 2>&1)
  agent_status=$?
  case $agent_status in
    0) ;;
    1) identities="" ;;
    2)
      printf 'SSH: Starting an agent because the current connection is unavailable.\n' >&2
      agent_settings=$(ssh-agent -s) || {
        printf 'SSH: Failed to start an agent.\n' >&2
        return 1
      }
      eval "$agent_settings" > /dev/null || {
        printf 'SSH: Failed to configure the agent environment.\n' >&2
        return 1
      }
      identities=""
      ;;
    *)
      printf 'SSH: Failed to list agent identities: %s\n' "$identities" >&2
      return 1
      ;;
  esac

  # A matching public key distinguishes identities from private-key backup files.
  for public_key in "$HOME"/.ssh/identity.*.pub(N); do
    key=${public_key%.pub}
    if [[ ! -f "$key" ]]; then
      printf 'SSH: Missing private key for %s\n' "$public_key" >&2
      result=1
      continue
    fi
    key_details=$(ssh-keygen -lf "$public_key") || {
      printf 'SSH: Failed to read the fingerprint of %s\n' "$public_key" >&2
      result=1
      continue
    }
    key_fields=(${(z)key_details})
    fingerprint=${key_fields[2]}
    [[ " $identities " == *" $fingerprint "* ]] && continue

    if ! chmod 600 "$key"; then
      result=1
      continue
    fi
    if ! ssh-add "$key"; then
      printf 'SSH: Failed to add %s\n' "$key" >&2
      result=1
    else
      identities+=$'\n'"$key_details"
    fi
  done
  return $result
}
