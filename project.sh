#!/bin/sh
if ! [ -x "$(command -v pod)" ]; then
  echo 'Error: cocoapods is not found.' >&2
  read -p "Do you want to install cocoapods? (y/n)" -n 1 -r
  echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
	echo "installing cocoapods"
   	sudo gem install cocoapods
	echo ""
	echo "Installing dependencies."
        pod install
    fi
  exit 1
else
  echo 'cocoapods is already installed' >&2
  pod install
  exit 1
fi
