#!/bin/bash

dart fix --apply
dart format --set-exit-if-changed .
flutter analyze .
