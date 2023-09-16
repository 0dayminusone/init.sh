# README

## Contents

0. General
1. Fedora
2. Opensuse
3. Arch

## General

- Always aim to use the minimal iso provided by distros, to ensure repeatability & reproducible systems
- YOU SHOULD NOT RUN THE INIT.SH SCRIPT:
  1. FROM THE BACKUP FOLDER
  2. NOT FROM THE ~ USER DIRECTORY
  3. RUN THE SCRIPT FROM THE TTY, ITS AVOIDS THINGS MESSING UP
- check if secure boot is enabled
- The initial 1st build proccess of rebos will take a very long time, but you MUST be there for the whole process to authenticate all the different managers, otherwise the whole process will timeout and fail

## Fedora

Use the minimal net iso, with only these packages chosen:

- 'Minimal Custom Fedora ISO' (dont even choose a DE)
- Netmanager submodules

## Opensuse

- Use the regular ISO for now, you can customise your packages still
- check if secure boot is enabled after
- Turning off secure boot, running the ISO, installing, then turning on secure boot in bios right before ur first boot, seems to work

## Arch

- Choose the regular arch ISO
- Mount backup + archinstall config before & after install
- import the archinstall config using "archinstall --config /path/to/file
- REMEMBER, WHEN INPUTTING PASSWORDS IN ARCHINSTALL, BY DEFAULT IT USES THE usa keyboard layout
- Use archinstall script in install env
- import the archinstall config, but remember you still need to config these things:
