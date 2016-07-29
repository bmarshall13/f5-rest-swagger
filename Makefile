

CODEGEN_TAG:=swagger-codegen:latest
VERS:=$(shell git describe --dirty=-dirty || echo "devel")
BUILD_INFO:=Codegen IMG: $(shell docker images -q $(CODEGEN_TAG))

REPO_BASE?=github.com/f5devcentral
GOIMPORT?=$(REPO_BASE)/go-bigip-rest
GITPREFIX?=https://$(REPO_BASE)/

all: build/go-bigip-rest.stamp

clean:
	rm -rf build

extra: build/ruby-f5-rest.stamp build/python-f5-rest.stamp build/javascript-f5-rest.stamp


build/%-bigip-rest.stamp: build/%-bigip-rest bigip.json Makefile templates/%/*
	mkdir -p build
	rm -rf build/$*-bigip-rest/* || true
	docker run --rm -v $(CURDIR):/wkdir $(CODEGEN_TAG) \
	    generate -i /wkdir/bigip.json \
	    -l $* -t /wkdir/templates/go \
	    -o /wkdir/build/$*-bigip-rest/ \
	    -D packageName=f5api,packageVersion=$(VERS) \
	    --additional-properties buildInfo='$(BUILD_INFO),goImportPath=$(GOIMPORT)'
	if [ "$*" == "go" ]; then cd build/$*-bigip-rest && go fmt *.go; fi
	cd build/$*-bigip-rest && rm -f git_push.sh pom.xml && git add .
	touch $@

# Check out the SDK to be updated
build/%-bigip-rest:
	mkdir -p build
	git clone $(GITPREFIX)/$@.git || git init $@

%.json: %.yaml
	python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)' < $< > $@
