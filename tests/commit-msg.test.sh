#!/bin/sh
# Self-check for plugins/odhyp/templates/commit-msg. Run: sh tests/commit-msg.test.sh
hook="$(dirname "$0")/../plugins/odhyp/templates/commit-msg"
t=$(mktemp -d); fail=0
chk() { printf '%s\n' "$2" > "$t/m"; sh "$hook" "$t/m" 2>/dev/null; r=$?
        [ "$r" = "$1" ] || { echo "FAIL (want exit $1): $2"; fail=1; }; }
chk 0 'feat(dashboard): add layout'
chk 0 'fix!: drop py3.8'
chk 0 'chore(release): v0.2.0'
chk 0 "# comment
feat: x"
chk 0 'Merge branch main'
chk 0 'Revert "feat: x"'
chk 1 'added stuff'
chk 1 'feat:no space'
chk 1 'Feat(x): y'
chk 1 'feat(Bad_Scope): y'
chk 1 'feature: y'
chk 1 ''
rm -r "$t"
[ $fail = 0 ] && echo "commit-msg: all pass"; exit $fail
