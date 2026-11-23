#!/usr/bin/env bash
# Boucle de veille : vérifie le site toutes les INTERVAL secondes pendant DURATION secondes.
# GitHub ne lance les tâches planifiées que toutes les quelques heures ; en bouclant à
# l'intérieur d'un même job (6 h max sur GitHub), on garde une vérification toutes les 2 minutes.
set -u

INTERVAL="${INTERVAL:-120}"
DURATION="${DURATION:-20400}"   # 5 h 40, sous la limite de 6 h d'un job GitHub
END=$(( $(date +%s) + DURATION ))

git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"

run=0
while :; do
  run=$((run + 1))
  echo "::group::Passage $run — $(date -u +%H:%M:%S) UTC"
  OUT="$(mktemp)"
  GITHUB_OUTPUT="$OUT" python scraper.py || echo "scraper en erreur (code $?), on continue"

  if grep -q '^has_new=true' "$OUT"; then
    export MAIL_SUBJECT
    MAIL_SUBJECT="$(grep '^subject=' "$OUT" | tail -1 | cut -d= -f2-)"
    MAIL_HTML_FILE=notification.html python send_mail.py || echo "envoi du mail en erreur"
  fi
  rm -f "$OUT"

  if [[ -n "$(git status --porcelain state.json)" ]]; then
    git add state.json
    git commit -q -m "chore: maj état veille CROUS [skip ci]"
    git pull --rebase -q || true
    git push -q || echo "push de l'état en échec, on réessaiera"
  fi
  echo "::endgroup::"

  (( $(date +%s) + INTERVAL >= END )) && break
  sleep "$INTERVAL"
done
echo "Fin de la boucle après $run passages."
