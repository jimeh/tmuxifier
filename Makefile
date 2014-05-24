test: prepare
	./test.sh

prepare: test/assert.sh test/stub.sh

test/assert.sh:
	test -f "test/assert.sh" || ( \
		echo "fetching test/assert.sh..." && \
		curl -s -L -o test/assert.sh \
			https://raw.github.com/lehmannro/assert.sh/v1.0.2/assert.sh \
	)

update-assert.sh: remove-assert.sh test/assert.sh

remove-assert.sh:
	test -f "test/assert.sh" && \
		rm "test/assert.sh" && \
		echo "removed test/assert.sh"

test/stub.sh:
	test -f "test/stub.sh" || ( \
		echo "fetching test/stub.sh..." && \
		curl -s -L -o test/stub.sh \
			https://raw.github.com/jimeh/stub.sh/v0.3.0/stub.sh \
	)

update-stub.sh: remove-stub.sh test/stub.sh

remove-stub.sh:
	test -f "test/stub.sh" && \
		rm "test/stub.sh" && \
		echo "removed test/stub.sh"

.SILENT:
.PHONY: test prepare \
	test/assert.sh update-assert.sh remove-assert.sh \
	test/stub.sh update-stub.sh remove-stub.sh
