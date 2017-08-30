.phony: default all build clean watch upload

ICED=node_modules/.bin/iced
BUILD_STAMP=build-stamp

default: build
all: build

build/%.js: src/%.iced
	$(ICED) -I browserify -c -o `dirname $@` $<

$(BUILD_STAMP): \
	build/cli.js \
	build/alexa.js \
	build/api.js \
	build/secrets.js
	date > $@

build: $(BUILD_STAMP)

build.zip: $(BUILD_STAMP)
	zip -r --exclude="*.git*" build.zip .

clean:
	rm -rf build

watch:
	ls src/* | entr -r sh -c "make && node build/cli.js"

upload: build.zip
	aws lambda update-function-code --zip-file=fileb://build.zip --function-name=$(LAMBDA_ARN)
