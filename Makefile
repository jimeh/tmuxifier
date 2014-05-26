test: bootstrap
	./test-runner.sh

bootstrap: test-runner.sh test/assert.sh test/stub.sh

clean: remove-test-runner.sh remove-assert.sh remove-stub.sh

test-runner.sh:
	test -f "test-runner.sh" || \
		echo "fetching test-runner.sh..." && \
		curl -s -L -o test-runner.sh \
			https://github.com/jimeh/test-runner.sh/raw/v0.1.0/test-runner.sh && \
		chmod +x test-runner.sh

remove-test-runner.sh:
	( \
		test -f "test-runner.sh" && rm "test-runner.sh" && \
		echo "removed test-runner.sh"\
	) || exit 0

update-test-runner.sh: remove-test-runner.sh test-runner.sh

test/assert.sh:
	test -f "test/assert.sh" || ( \
		echo "fetching test/assert.sh..." && \
		curl -s -L -o test/assert.sh \
			https://raw.github.com/lehmannro/assert.sh/v1.0.2/assert.sh \
	)

remove-assert.sh:
	test -f "test/assert.sh" && \
		rm "test/assert.sh" && \
		echo "removed test/assert.sh"

update-assert.sh: remove-assert.sh test/assert.sh

test/stub.sh:
	test -f "test/stub.sh" || ( \
		echo "fetching test/stub.sh..." && \
		curl -s -L -o test/stub.sh \
			https://raw.github.com/jimeh/stub.sh/v1.0.1/stub.sh \
	)

remove-stub.sh:
	test -f "test/stub.sh" && \
		rm "test/stub.sh" && \
		echo "removed test/stub.sh"

update-stub.sh: remove-stub.sh test/stub.sh

.SILENT:
.PHONY: test bootstrap clean \
	test-runner.sh remove-test-runner.sh update-test-runner.sh \
	test/assert.sh remove-assert.sh      update-assert.sh \
	test/stub.sh   remove-stub.sh        update-stub.sh
