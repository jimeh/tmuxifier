#! /usr/bin/env bash
source "../test-helper.sh"
source "${root}/lib/util.sh"

#
# calling-help() tests.
#

# Returns 0 when "--help" is part of passed arguments.
assert_raises 'calling-help --help' 0
assert_raises 'calling-help foo --help' 0
assert_raises 'calling-help --help bar' 0
assert_raises 'calling-help foo --help bar' 0

# Returns 0 when "-h" is part of passed arguments.
assert_raises 'calling-help -h' 0
assert_raises 'calling-help foo -h' 0
assert_raises 'calling-help -h bar' 0
assert_raises 'calling-help foo -h bar' 0

# Returns 1 when neither "--help" or "-h" is not part of passed arguments.
assert_raises 'calling-help' 1
assert_raises 'calling-help foo' 1
assert_raises 'calling-help foo bar' 1

# Returns 1 when "--help" is part of passed arguments, but not free-standing.
assert_raises 'calling-help --help-me' 1
assert_raises 'calling-help foo--help' 1

# Returns 1 when "-h" is part of passed arguments, but not free-standing.
assert_raises 'calling-help -hj' 1
assert_raises 'calling-help welcome-home' 1

# End of tests.
assert_end "calling-help()"


#
# calling-complete() tests.
#

# Returns 0 when "--complete" is part of passed arguments.
assert_raises 'calling-complete --complete' 0
assert_raises 'calling-complete foo --complete' 0
assert_raises 'calling-complete --complete bar' 0
assert_raises 'calling-complete foo --complete bar' 0

# Returns 1 when "--complete" is not part of passed arguments.
assert_raises 'calling-complete' 1
assert_raises 'calling-complete foo' 1
assert_raises 'calling-complete foo bar' 1

# Returns 1 when "--complete" is part of passed arguments, but not free-standing.
assert_raises 'calling-complete --complete-me' 1
assert_raises 'calling-complete foo--complete' 1

# End of tests.
assert_end "calling-complete()"
