# ImageMagick Dependencies

This repository contains the scripts and tools needed to clone and manage the third-party dependencies required for building ImageMagick on Windows.

## Overview

ImageMagick is built with a number of third-party libraries that provide support for various image formats, compression algorithms, and other functionality. This project contains the necessary scripts to automatically clone and organize these libraries for the build process.

## Requirements

• Git for Windows
• Internet connection for cloning repositories
• Visual Studio 2017 (or newer) for building the dependencies

## Getting Started

### Clone Dependencies

To clone all the required third-party libraries for ImageMagick, run the appropriate clone script:

```cmd
clone-dependencies.cmd
```

### Run Configure.exe

Running the command `.github\build\windows\download-configure.sh` will download the `Configure` program, which is used to set up the build environment for the depndences of ImageMagick. The executable will be placed in the `Configure` folder.

### Build Dependencies

Depending on which options were chosen when running `Configure` a solution will be created in the `ImageMagick-Windows`folder that can be opened in Visual Studio. Open the solution and build it.
