

CODEGEN_TAG:=swagger-codegen:latest
VERS:=$(shell git describe --dirty=-dirty || echo "devel")
BUILD_INFO:=Codegen IMG: $(shell docker images -q $(CODEGEN_TAG))
GITPREFIX?=https://github.com/f5devcentral/

all: build/go-bigip-rest.stamp

clean:
	rm -rf build

extra: build/ruby-f5-rest.stamp build/python-f5-rest.stamp build/javascript-f5-rest.stamp


build/%-bigip-rest.stamp: build/%-bigip-rest ltm.json Makefile templates/%/*
	mkdir -p build
	rm -rf build/$*-bigip-rest/* || true
	docker run --rm -v $(CURDIR):/wkdir $(CODEGEN_TAG) \
	    generate -i /wkdir/ltm.json \
	    -l $* -t /wkdir/templates/go \
	    -o /wkdir/build/$*-bigip-rest/ \
	    -D packageName=f5api,packageVersion=$(VERS) \
	    --additional-properties buildInfo='$(BUILD_INFO)'
	cd build/$*-bigip-rest && git add .
	touch $@

# Check out the SDK to be updated
build/%-bigip-rest:
	mkdir -p build
	git clone $(GITPREFIX)/$@.git || git init $@

%.json: %.yaml
	python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)' < $< > $@
