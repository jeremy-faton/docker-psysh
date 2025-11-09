#!/usr/bin/env sh
phive install --trust-gpg-keys 41539BBD4020945DB378F98B2DF45277AEF09A2F humbug/box
phive install --trust-gpg-keys 161DFBE342889F01DDAC4E61CBB3D576F2A0946F composer
mv /app/tools/composer /usr/local/bin/composer
mv /app/tools/box /usr/local/bin/box