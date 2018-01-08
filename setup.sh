#!/bin/bash

WPILIB="https://github.com/wpilibsuite/allwpilib.git"
WPIUTIL="https://github.com/wpilibsuite/wpiutil.git"
CSCORE="https://github.com/wpilibsuite/cscore.git"
NTCORE="https://github.com/wpilibsuite/ntcore.git"

setup()
{
	if [ ! -d "build" ]; then
		mkdir build
		git clone $WPILIB build/wpilib
		git clone $WPIUTIL build/wpilib/wpiutil
		git clone $CSCORE build/wpilib/cscore
		git clone $NTCORE build/wpilib/ntcore
	fi
}

build_wpilib()
{
	echo "Building..."
	cd build/wpilib
	./gradlew :wpilibc:build -PreleaseBuild
	#wpiutil/gradlew build -PreleaseBuild
	#cscore/gradlew build -PreleaseBuild
	#ntcore/gradlew build -PreleaseBuild
	cd ../../
	echo "Finished..."
}

converge()
{
	mapfile -t LIBS < <( find build/wpilib -type f -name "*.so" )
	mkdir -p build/lib/
	mkdir -p build/src/
	for lib in $LIBS
	do
		cp "${lib}" build/lib/
	done

	cp -r build/wpilib/wpilibc/src/main/native/* build/src
	cp -r build/wpilib/wpiutil/src/main/native/* build/src
	cp -r build/wpilib/ntcore/src/main/native/* build/src
	cp -r build/wpilib/cscore/src/main/native/* build/src
}

go() {
	setup
	build_wpilib
	converge
}

go
