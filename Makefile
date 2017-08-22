ICED=node_modules/.bin/iced
BUILD_STAMP=build-stamp

default: build
all: build

build/%.js: src/%.iced
	$(ICED) -I browserify -c -o `dirname $@` $<

$(BUILD_STAMP): \
	build/cli.js
	date > $@

build: $(BUILD_STAMP)

clean:
	rm -rf build
