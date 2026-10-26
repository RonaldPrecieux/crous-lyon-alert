# Veille logements CROUS Lyon 🏠

Surveille [trouverunlogement.lescrous.fr](https://trouverunlogement.lescrous.fr) sur la zone Lyon/Villeurbanne
toutes les 5 minutes via GitHub Actions, et envoie un email dès qu'un **nouveau** logement apparaît
(titre, prix, adresse, lien direct).

Basé sur [btalebelale/bella-crous](https://github.com/btalebelale/bella-crous) — Python standard, aucune dépendance.

## Configuration (une seule fois)

Dans **Settings → Secrets and variables → Actions → Secrets → New repository secret** :

| Nom             | Valeur                                                        |
|-----------------|---------------------------------------------------------------|
| `MAIL_USERNAME` | l'adresse Gmail qui envoie les alertes                        |
| `MAIL_PASSWORD` | un mot de passe d'application Gmail (16 caractères)           |
| `MAIL_TO`       | l'adresse qui reçoit les alertes (plusieurs : séparées par `,`) |

Mot de passe d'application : activer la validation en 2 étapes Google, puis
<https://myaccount.google.com/apppasswords>.

Vérifier ensuite : **Actions → Test email (manuel) → Run workflow**.

## Changer de zone

Modifier `SEARCH_URL` dans `.github/workflows/crous.yml` (une URL par ligne pour plusieurs zones).
L'identifiant de campagne (`tools/47`) change à chaque année universitaire.

## Bon à savoir

- Les crons GitHub peuvent avoir quelques minutes de retard en cas de charge.
- Le premier passage envoie un mail avec tous les logements déjà en ligne, ensuite seulement les nouveaux.
- La réservation reste manuelle : clique sur le lien du mail, connecté à ton compte CROUS.
