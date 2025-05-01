![Default](https://github.com/Antibodyarmy/Batch-extract-xiso/blob/main/Images/Default.JPG)


# About This Tool

This is Version 2.0 of the v1 batch extraction tool I made for myself to use alongside extract-xiso.exe

It comes preset to remove the $systemupdate folder and run quitely with a percentage bar, the primary changes to this from my personal 1.0 is adding color and making it easier to update the comands. 

This tool is to be used with https://github.com/XboxDev/extract-xiso and come pre packaged with the extract-xiso.exe that I tested it with but you are encouraged to download the latest version from the official repo. 


# How To Use this tool

Make sure you dont have any weird symbols in the name of your iso files for example. ! ? > < / \ [ ] 

This tool will tolerates spaces but has broken on with iso's named for example " Kinect adventures! " 

Double click the batch-xiso extraction v2.0.bat it will prompt you for an output directory type your desired output directory or simply press ENTER to output the extracted iso's into output

Tell the script if you want to delete the original iso Y/y for yes N/n For no 

>[!WARNING]
>If you have not successfuly extracted your ISO's and this is your first time you are encouraged to type N/n to keep the ISO files

You can change the command argumernts for extract-xiso to use on line 8 of the .bat file

By default the command arguments are --x -q -s -d 


> [!CAUTION]
>
> The command argument -d might be nessisary for proper operation of the script removal of -d broke v1 and has not been tested in v2.0
> 


>[!NOTE]
> For exmaple if you want to keep your $systemupdate folder change line 8
>
>From
>
>      set "xiso_cmd=extract-xiso -x -q -s -d"
>
>To 
>
>      set "xiso_cmd=extract-xiso -x -q -d"
>
>

>[!NOTE]
>
>
>If you want to see the progress of extraction by removing -q/-Q it will be located in the outputfolder's LogFile.txt
>
>

When used properly the tool should output something like this. 

![Example-Use](https://github.com/Antibodyarmy/Batch-extract-xiso/blob/main/Images/example%20use.gif)

# Features/Changelog


                                      Release Notes - v2.0
                         - SKIPS SYSTEM UPDATE FOLDERS BY DEFAULT
                         - Folder Selection (default: output)
                         - Auto Extraction without pauses
                         - Improved Colored Progress Bar
                         - Option to delete ISOs after extraction
                         - Full detailed logging with summary
                         - Edit line 8 edit command (removing -q/-Q will only output to logfile)






# Extract-xiso.exe readme

# extract-xiso

A command line utility created by [*in*](mailto:in@fishtank.com) to allow the creation, modification, and extraction of XISOs. Currently being maintained and modernized by the [*XboxDev organization*](https://github.com/XboxDev/XboxDev).

## Features

- Create XISOs from a directory.

- Extract XISO content to a directory.

- Multi-Platform and Open-Source.

## Usage

The `extract-xiso` utility can run in multiple modes: *create*, *list*, *rewrite*, and *extract*.

### Create `-c`

Create an XISO from a directiory.
```
# Create halo-2.iso in the current directory containing the files within ./halo-2.iso
./extract-xiso -c ./halo-2

# Create halo-ce.iso in the /home/me/games directory containing files in the ./halo-ce directory
./extract-xiso -c ./halo-ce /home/me/games/halo-ce.iso
```

### List `-l`

List the file contents within an XISO file.
```
# Get file contents of a XISO
./extract-xiso -l ./halo-ce.iso

# List file contents of multiple XISOs
./extract-xiso -l ./halo-2.iso ./halo-ce.iso
```

### Rewrite `-r`

Rewrites filesystem structure of an XISO.
```
# Rewrites XISO
./extract-xiso -r ./halo-ce.iso
# Can be batched
./extract-xiso -r ./halo-ce.iso ./halo-2.iso
```

### Extract `-x`

Extract XISO contents to a directory.
```
# Default mode when no arguments given, extracts to ./halo-ce/
./extract-xiso ./halo-ce.iso

# Can be given a target directory
./extract-xiso ./halo-2.iso -d /home/games/halo-2/
```

### Options

`extract-xiso` has a few optional arguments that can be provided in different modes:
```
-d <directory>      In extract mode, expand xiso in <directory>.
                    In rewrite mode, rewrite xiso in <directory>.
-D                  In rewrite mode, delete old xiso after processing.
-h                  Print this help text and exit.
-m                  In create or rewrite mode, disable automatic .xbe
                      media enable patching (not recommended).
-q                  Run quiet (suppress all non-error output).
-Q                  Run silent (suppress all output).
-s                  Skip $SystemUpdate folder.
-v                  Print version information and exit.
```

## Building

### Requirements

- cmake
- make
- gcc

### Windows / macOS / Linux

After requirements are installed with your distribution's package manager (or homebrew for macOS), open terminal and change directory to the project root. Then run the following build commands:

```
# Clone Repo
git clone https://github.com/XboxDev/extract-xiso.git

# cd into directory
cd extract-xiso

# Create working directory
mkdir build
cd build

# Build project
cmake ..
make
```

The compiled binary should now be in the `extract-xiso/build` directory as `extract-xiso`.
