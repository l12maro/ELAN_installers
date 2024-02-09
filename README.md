# Installers
This repository provides instructions to install Speech-to-text recognizers in your local ELAN folder. 

## Guide to use

The repository contains different branches depending on the desired use:

### Main 

Main includes the nsi file used to create the installer for all of the recognizers locally. It can be used by changing the local paths to modify the provided installer. The local paths to be changed are indicated in the file by the tag "local_dir"

*Requirements*
* Windows OS
* Cmdi and exe files from the different branches within the current repository:
```
git clone -b <branch> <https://github.com/l12maro/Installers>
```
* [NSIS system](https://nsis.sourceforge.io/Download)

### Other branches

Every one of the other branches includes the required documents to create a pyinstaller bundle file locally. This pyinstaller bundle file will be distributed by the general installer found in Main, along with the CMDI file required for processing the .exe file within ELAN.

*Requirements*
* Windows OS
* [Python 3](https://www.python.org/) (tested with Python 3.9)
* Data files bundled with each of the recognizers should be stored in the same directory as the files found in this branch:
    - SileroVAD-ELAN: 
        * clone [Silero-vad](https://github.com/snakers4/silero-vad)
    - Voxseg-elan:
         * [ffmpeg](https://ffmpeg.org)
         * [Voxseg](https://github.com/NickWilkinson37/voxseg), installed with all of its dependencies. This can be done with `pip` and a clone of the current Voxseg GitHub repository.
         * [pydub](https://github.com/jiaaro/pydub), installed in the same virtual environment as Voxseg (tested with v0.25.1
         * [tensorflow](https://pypi.org/project/tensorflow/), installed in the same virtual environment as Voxseg and pydub (tested with v2.10.0).

*Steps*

1. Clone the repository branch within the "app/extensions" subdirectory of your local ELAN directory. 
```
git clone -b <branch> <https://github.com/l12maro/Installers>
```

2. Set and activate virtual environment, install pyinstaller:
```
python3 -m virtualenv
source venv/Scripts/activate
pip install pyinstaller
```

3. Install data files that must be bundled with the chosen recognizer (see Requirements)

4.1. Run pyinstaller on .spec file provided. You should find the .exe file within .\dist.
```
pyinstaller -F <spec file>
```

4.2.  Alternatively, you may bundle the file using the python and specifying the paths of the dependencies, if the additional data files are located  in a different directory. Add them manually to the bundled file either:
* From the command line:
```
pyinstaller -F --add-data <Path_Folder1> --add-data <Path_Folder2> ... <python file> 
```

* Manually from the .spec file:
    - Run pyinstaller on python file.
         ```
         pyinstaller -F <python file>
         ```
    - Open .spec file. In Analysis > datas, add folders path, e.g.:
         ```
         a = Analysis(...
                  datas=[ ('path1', 'path1'),  ('path2', '.path2') ... ],
                  ...
                  )
         ```
    - Recompile .spec file
         ```
         pyinstaller -F <spec file>
         ```
