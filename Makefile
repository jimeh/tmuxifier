test: bootstrap
	./test-runner.sh

bootstrap: test-runner.sh test/assert.sh test/stub.sh
clean: remove_test-runner.sh remove_test/assert.sh remove_test/stub.sh
update: update_test-runner.sh update_test/assert.sh update_test/stub.sh

test-runner.sh:
	echo "fetching test-runner.sh..." && \
	curl -s -L -o test-runner.sh \
		https://github.com/jimeh/test-runner.sh/raw/v0.2.0/test-runner.sh && \
	chmod +x test-runner.sh

remove_test-runner.sh:
	( \
		test -f "test-runner.sh" && rm "test-runner.sh" && \
		echo "removed test-runner.sh"\
	) || exit 0

update_test-runner.sh: remove_test-runner.sh test-runner.sh

test/assert.sh:
	echo "fetching test/assert.sh..." && \
	curl -s -L -o test/assert.sh \
		https://raw.github.com/lehmannro/assert.sh/v1.0.2/assert.sh

remove_test/assert.sh:
	test -f "test/assert.sh" && \
		rm "test/assert.sh" && \
		echo "removed test/assert.sh"

update_test/assert.sh: remove_test/assert.sh test/assert.sh

test/stub.sh:
	echo "fetching test/stub.sh..." && \
	curl -s -L -o test/stub.sh \
		https://raw.github.com/jimeh/stub.sh/v1.0.1/stub.sh

remove_test/stub.sh:
	test -f "test/stub.sh" && \
		rm "test/stub.sh" && \
		echo "removed test/stub.sh"

update_test/stub.sh: remove_test/stub.sh test/stub.sh

.SILENT:
.PHONY: test bootstrap clean \
	remove_test-runner.sh update_test-runner.sh \
	remove_test/assert.sh update_test/assert.sh \
	remove_test/stub.sh   update_test/stub.sh
