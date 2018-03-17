# see https://github.com/olivere/blz/issues/14
TEST_SOURCE_URL = https://github.com/olivere/blz/files/1820218/BLZ_20180305.txt
TEST_TARGET_URL = https://github.com/olivere/blz/files/1820224/2018_03_05.tsv.gz

.PHONY: test
test: target.tsv compiled.tsv
	diff -a target.tsv compiled.tsv && echo "SUCCESS: files identical" || echo "ERROR: file not identical"

.PHONY: clean
clean:
	rm -f source.txt target.tsv compiled.tsv

source.txt:
	curl -sSL $(TEST_SOURCE_URL) >$@

target.tsv:
	curl -sSL $(TEST_TARGET_URL) | gunzip --stdout | sort >$@

compiled.tsv: source.txt
	./convert.rb $< | sort >$@
