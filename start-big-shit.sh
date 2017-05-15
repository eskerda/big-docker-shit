#!/usr/bin/env bash

set -e
sh create-machines.sh
sh start-shit.sh
sh test-shit.sh
