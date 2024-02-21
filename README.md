# Installers
This repository provides instructions to install Speech-to-text recognizers in your local ELAN folder. 

## Guide to use

### Main 

Main includes two files:
1. Installer.exe, which can be used standalone for the installation of the recognizers [SileroVAD-Elan](https://github.com/l12maro/SileroVAD-Elan) and [Voxseg-ELAN](https://github.com/coxchristopher/voxseg-elan).
2. Installer.nsi, which can be used to replicate the creation of the installer.

### SileroVAD-ELAN
The branch SileroVAD-ELAN includes the .spec file used to bundle the SileroVAD-ELAN recognizer into an executable file.

### Voxseg-elan
The branch Voxseg-elan includes the .spec file used to bundle the Voxseg-elan recognizer into an executable file.

### Create an installer

*Requirements*
* Windows OS
* [Python 3](https://www.python.org/) (tested with Python 3.9)
* NSIS system](https://nsis.sourceforge.io/Download)
* Data files bundled with each of the recognizers and their dependencies. They should be stored in the same directory as the nsi file:
    - SileroVAD-ELAN:
        * clone [Silero-vad](https://github.com/snakers4/silero-vad).
        * clone [SileroVAD-ELAN](https://github.com/l12maro/SileroVAD-Elan).
    - Voxseg-elan:
         * clone [Voxseg-ELAN](https://github.com/coxchristopher/voxseg-elan).
         * [ffmpeg](https://ffmpeg.org).
         * [Voxseg](https://github.com/NickWilkinson37/voxseg), installed with all of its dependencies. This can be done with `pip` and a clone of the current Voxseg GitHub repository.
         * [pydub](https://github.com/jiaaro/pydub), installed in the same virtual environment as Voxseg (tested with v0.25.1).
         * [tensorflow](https://pypi.org/project/tensorflow/), installed in the same virtual environment as Voxseg and pydub (tested with v2.10.0).


1. Clone the repository
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


4. Bundle data files

4.1. Run pyinstaller on .spec file provided in each of the branches. You should find the .exe file within .\dist.
```
pyinstaller -F <spec file>
```

4.2.  Alternatively, you may bundle the file specifying the paths of the dependencies, if the additional data files are located  in a different directory. Add them manually to the bundled file either:
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

5. Change the local paths to provided in the nsi file with the local path of the bundle within your computer. The local paths to be changed are indicated in the file by the tag "local_dir"

