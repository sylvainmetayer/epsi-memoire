# Mémoire EPSI

[![Build Status](https://travis-ci.org/sylvainmetayer/epsi-memoire.svg?branch=master)](https://travis-ci.org/sylvainmetayer/epsi-memoire)
[![GitHub release](https://img.shields.io/github/release/sylvainmetayer/epsi-memoire.svg)](http://github.com/sylvainmetayer/epsi-memoire/releases/latest)

> Mémoire EPSI - Promotion 2019 - Sylvain METAYER

## Problématique 

Comment l'automatisation peut permettre d'améliorer le cycle de vie d'une application ?

## Pre-requis

- `latex-full`
- `python-pygments`

Si l'IDE utilisé pour LateX est TexStudio, il peut être bien d'installer également [LanguageTool](https://languagetool.org/download/) afin de pouvoir profiter d'une correction orthographique complète.

## Build

- `make build`

- With docker `make docker-build`

## Tags

- `make tag`

Les PDF seront générés à chaque tag et seront ajoutés aux [releases Github](https://github.com/sylvainmetayer/epsi-memoire/releases)

## Upload Dockerfile

- `docker tag latex-debian sylvainmetayer/latex-debian`
- `docker push new sylvainmetayer/latex-debian`

