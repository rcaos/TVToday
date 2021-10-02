#!/bin/sh
if which swiftlint >/dev/null; then

  if [ $1 == "feature" ]; then
    swiftlint --config ../../BuildPhases/.swiftlint.yml
  else
    swiftlint --config ../BuildPhases/.swiftlint.yml
  fi

else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
