#!/usr/bin/env bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.

set -e

# Clone the spec or the proposal repository.
prepare_spec() {
    NAME=$1

    if [ -d ${NAME} ]; then
        (cd ${NAME}; git pull)
    else
        git clone --depth=1 https://github.com/tc39/${NAME}
    fi
}

# List of specs and proposals to include into the WebIDL.
# Proposal should be placed after the spec that the proposal updates.
SPECS=$(cat <<EOF
specs/ecma262/spec.html
specs/ecma402/spec/index.html
EOF
)

if ! [ "x$1" = "x--cached" ]; then
    mkdir -p specs
    cd specs

    for SPEC in ${SPECS}; do
        NAME=$(echo ${SPEC} | cut -d "/" -f 2)
        prepare_spec ${NAME}
    done

    cd ..

    python3 -m venv .venv
    ./.venv/bin/pip install --upgrade pip
    ./.venv/bin/pip install -r requirements.txt
fi

(
    for SPEC in ${SPECS}; do
        NAME=$(echo ${SPEC} | cut -d "/" -f 2)
        echo https://github.com/tc39/${NAME}
        (cd specs/${NAME}; git log -1 --pretty="Revision: %H")
        echo ""
    done

) > usedSources.txt

mkdir -p output
./.venv/bin/python3 ./es2idl.py -c new -o output/SpecNew.webidl ${SPECS}
./.venv/bin/python3 ./es2idl.py -c compat -o output/SpecCompat.webidl ${SPECS}
