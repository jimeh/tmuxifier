#! /usr/bin/env bash
source "../../test-helper.sh"
source "${root}/lib/layout-helpers.sh"

#
# __expand_path() tests.
#

# Setup.
realHOME="$HOME"
HOME="/home/test-user"

# When given a path containing "~", it expands "~" to "$HOME".
assert '__expand_path "~/Foo/Bar"' "${HOME}/Foo/Bar"

# When given a path without "~", it returns path as is.
assert '__expand_path "/path/to/file"' "/path/to/file"

# When given a path containing spaces, it returns path correctly.
assert '__expand_path "~/Path To/File"' "${HOME}/Path To/File"

# Tear down.
HOME="$realHOME"
unset realHOME

# End of tests.
assert_end "__expand_path()"
