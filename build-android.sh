#!/bin/sh

output_directory=./build/app/outputs/flutter-apk

flutter build apk --split-per-abi


zip -r $output_directory/codelink-mobile.zip $output_directory/app-arm64-v8a-release.apk
tar -czvf $output_directory/codelink-mobile.tgz $output_directory/app-arm64-v8a-release.apk
