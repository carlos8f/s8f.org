#!/usr/bin/env bash

FILE="_posts/`date +%F-%s`.md"
cat .new > $FILE
echo "wrote $FILE"
