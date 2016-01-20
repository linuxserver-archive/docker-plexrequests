#!/bin/bash
HOME=/root
curl -sL https://install.meteor.com | sed s/--progress-bar/-sL/g | /bin/sh
