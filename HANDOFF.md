# HANDOFF — Charge CPU du Mac (sysstats)

- **Session** : 2026-11-22
- **Reprise prévue** : 2026-11-26 / 2026-11-27, pour comparer les stats après correctifs
- **Données** : `~/.local/share/sysstats/stats.db`, rapports dans `~/.local/share/sysstats/reports/`

## Situation de référence (avant correctifs)

157 échantillons, du 2026-11-21 11:05 au 2026-11-22 10:43. Mac M1 Pro, 10 cœurs.

| Indicateur | Valeur |
|---|---|
| CPU système moyen | 56 % (pics à 100 %) |
| Load moyen / max | 9,0 / 80,8 |

Le CPU par processus est en % d'un cœur. Il est sous-estimé pour les processus très courts, car l'échantillonnage a lieu toutes les 5 min.

| Processus | CPU moyen | Pic | RAM |
|---|---|---|---|
| `python: gcloud.py` | 104 % | 452 % | 261 Mo |
| `mds_stores` | 26 % | 107 % | 1,2 Go |
| `pi` | 22 % | 132 % | 2,3 Go |
| Google Chrome (88 processus) | 17 % | 492 % | 7,4 Go |
| `mediaanalysisd` | 16 % | 66 % | 80 Mo |
| `node: processChild.js` (jest) | 11 % | 635 % | 4,7 Go |
| `com.apple.Virtualization.VirtualMachine` (colima) | 10 % | 35 % | 819 Mo |
| PixInsight | 7 % | 707 % | 793 Mo |

## Ce qui a été fait

### 1. Mod Herdr `iam` : le plus gros consommateur
- **Cause** : toutes les 60 s, `pam.py list` lançait un `gcloud pam grants list` par entitlement (101), soit environ 150 s de CPU par minute.
- **Correctif** : `pam.py` appelle directement les API REST PAM et Resource Manager, avec un jeton `gcloud auth print-access-token` mis en cache 50 min dans `~/.config/herdr-app/data/pam_token.json` (droits 0600).
  - Une mise à jour coûte maintenant 0,4 à 0,5 s de CPU.
  - Un scan en erreur n'est plus mis en cache ; un scan vide est gardé 1 h au lieu de 7 jours.
- **Mergé** : PR jjmartres/herdr-app-config#6.
- **Ce qu'on doit voir** : plus aucun `gcloud.py pam grants list` dans `pinfo`.

### 2. Spotlight (`mds_stores`)
- **Cause** : `~/Repositories` (environ 1 million d'éléments indexés), `~/go`, `~/Astro`, etc.
- **Exclus de l'index** (Réglages Système → Spotlight → Confidentialité des recherches) : `~/Repositories`, `~/go`, `~/Astro`, `~/Personal`, `~/Desktop`, `~/Pictures`, `~/Movies`, `~/Music`, `~/Medias`, `~/Mail`, `~/Google Drive`, `~/Soulseek Downloads`, `~/Soulseek Chat Logs`, `/opt`, `/Volumes`.
- **Gardés volontairement** :
  - `/Applications`, `/System/Applications`, `~/Applications`, `~/Documents`, `~/Downloads` ;
  - `~/Library` et `/Library`, dont certaines applis ont besoin pour leur recherche ;
  - `/usr/local`, qu'on ne peut pas sélectionner dans les Réglages (24 éléments seulement).
- **Logs `gcloud`** : `core/disable_file_logging = true` dans les 74 configurations, et `~/.config/gcloud/logs` purgé (16 Go, 2,4 millions de fichiers).
  - Ce n'était pas la cause de `mds_stores`, car Spotlight n'indexe pas les dossiers cachés.
  - Une **nouvelle configuration `gcloud`** (`gcloud_config_generate`) n'aura pas ce réglage : il faudra l'ajouter.

### 3. `mediaanalysisd`
- C'était l'analyse visuelle des images indexées par Spotlight (`[Filesystem|Image]`), pas la photothèque Photos (9 Mo). Elle a tourné du 21/11 vers 12h jusqu'à 19h09, où elle a atteint 100 %.
- Rien à faire : les exclusions Spotlight réduisent ce qu'elle a à analyser.

### 4. Chrome
- Une seule instance avec trois profils (`fintecture`, `personal`, `Torrent`).
- L'Économiseur de mémoire est passé de Modéré à **Maximum** le 2026-11-22 vers 11h40.
- Les onglets sont gardés volontairement, et les groupes enregistrés sont déjà utilisés.
- Relevé le 2026-11-22 à 11h40 : 57 processus (50 renderers), 8,2 Go RSS, 2 % CPU.

## Non traité (laissé tel quel volontairement)
- `pi` : 22 % CPU, 2,3 Go. Il appelle `gcloud config config-helper` régulièrement, sans doute pour l'authentification Vertex.
- `jest` dans `nibbler_ts` : il appelle `gcloud config config-helper` car l'authentification GCP n'est pas simulée dans les tests unitaires. Pics `processChild.js` à 635 %.
- VM `colima` (environ 10 % en continu) et PixInsight (par rafales, normal).

## À vérifier à la reprise

```fish
set -l DB ~/.local/share/sysstats/stats.db
set -l since (date -v-4d +%s)

# CPU et load par jour
sqlite3 -header -column $DB "select date(ts,'unixepoch','localtime') j, round(avg(cpu_user+cpu_sys),1) cpu, round(avg(load1),2) load from samples where ts > $since group by j"

# Top processus sur la période
sqlite3 -header -column $DB "select name, round(sum(cpu)/(select count(distinct ts) from procs where ts > $since),1) cpu_moy, round(max(cpu),0) pic, round(avg(rss)/1048576.0) rss_mo, max(n) n from procs where ts > $since group by name order by cpu_moy desc limit 15"

# Plus aucun gcloud lancé par pam.py ?
sqlite3 $DB "select count(*) from pinfo where args like '%gcloud.py pam grants%' and first > $since"

# Toujours aucun log gcloud ?
find ~/.config/gcloud/logs -type f | wc -l
```

Points à contrôler :
- Le CPU moyen doit avoir nettement baissé (référence : 56 %) et `gcloud.py` doit avoir quasiment disparu du top.
- `mds_stores` et `mediaanalysisd` doivent être proches de 0 en dehors des pics ponctuels.
- Chrome : moins de processus et de RAM en moyenne (référence : 88 processus, 7,4 Go).
- Selon ce qui reste en tête : traiter `pi`, `jest` et `colima`.
