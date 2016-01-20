#!/bin/bash
curl -sL https://install.meteor.com | sed s/--progress-bar/-sL/g | /bin/sh
