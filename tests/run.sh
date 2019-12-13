#!/bin/bash

. ./bin/setup-test-environment.sh

# Wait for one minute before tests
sleep 60

if [[ "$NO_COLOURS" != "1" ]]; then
    RESTORE='\033[0m'
    RED='\033[00;31m' GREEN='\033[00;32m' YELLOW='\033[00;33m' BLUE='\033[00;34m' PURPLE='\033[00;35m' CYAN='\033[00;36m'
fi

TESTS_SUCCEED=0
TESTS_FAILED=0
TESTS_SKIPPED=0

TESTS=`ls -d ./tests/*/run.sh | cut -f3 -d'/'`

for TEST in $TESTS; do
	echo $TEST
	TEST_OUTPUT=$(./tests/$TEST/run.sh 2>&1)
	TEST_EXIT_CODE=$?

    case "$TEST_EXIT_CODE" in
        "0" )
            echo -e "${GREEN} Passed ${RESTORE}"
            TESTS_SUCCEED=$((TESTS_SUCCEED+1))
            ;;
        * )
            echo -e "${RED} Failed ${RESTORE}" "(Output: '${RED}$TEST_OUTPUT${RESTORE}')"
            TESTS_FAILED=$((TESTS_FAILED+1))
    esac
done;

exit $TESTS_FAILED