#!/bin/bash

### Add a file .dmrc to /etc/skel to prevent from new-user-issues
cat <<EOF | sudo tee /etc/skel/.dmrc
[Desktop]
Session=xubuntu
Language=de_DE
EOF
