# devops-scripts

Week 3 Linux shell scripts and Week 4 Git practice.

## Scripts
- maintain.sh: backs up a folder, rotates the log, keeps the newest backups
- hello.sh, greet.sh, sysinfo.sh, services.sh, vars.sh, check.sh: small practice scripts

## Author
Rayyosha

## Restore a backup
1. mkdir -p /tmp/restore
2. tar -xzf ~/backups/<newest>.tar.gz -C /tmp/restore
3. ls /tmp/restore  (check the files)
