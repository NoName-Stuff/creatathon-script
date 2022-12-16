#!/usr/bin/env bash

#
# Copyright (C) 2019 Saalim Quadri (danascape)
#
# SPDX-License-Identifier: Apache-2.0 license
#

# Set variable
DATE=$(date)
COMMIT_MSG="CI: Sync at"
COMMIT="$COMMIT_MSG $DATE"

# Deploy
git remote add origin https://github.com/NoName-Stuff/script
git fetch origin
git add json/
git commit -m "$COMMIT"
