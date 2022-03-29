#!/bin/zsh

ruby2d build --native game.rb # Compile the app for macOS
cp assets/* build/App.app/Contents/Resources # Copy assets to Resources file
cp assets/app.icns build/App.app/
mv build/App.app build/Space\ Base\ Command.app # Rename the app