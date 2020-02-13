builddir=./build/

all:
	corral run -- ponyc -o ${builddir} ./objc
	cd ${builddir}; ./objc

test:
	corral run -- ponyc -V=0 -o ${builddir} ./objc
	cd ${builddir}; ./objc




corral-fetch:
	@corral clean -q
	@corral fetch -q

corral-local:
	-@rm corral.json
	-@rm lock.json
	@corral init -q
	@corral add /Volumes/Development/Development/pony/pony.stringExt -q

corral-git:
	-@rm corral.json
	-@rm lock.json
	@corral init -q
	@corral add github.com/KittyMac/pony.stringExt.git -q

ci: corral-git corral-fetch all
	
dev: corral-local corral-fetch all
