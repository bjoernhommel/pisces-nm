# The Behavioral Text Mining Project
This project aims to obtain large quantities of data from questionnaires and instruments used in the behavioral sciences for purposes of training language models.

## Requirements
- [git](https://github.com/git-guides/install-git) for centralized data collection and project management
- [Visual Studio Code](https://code.visualstudio.com/) for completing tasks
- [python](https://www.python.org/downloads/) for running scripts
- [R](https://cran.r-project.org/bin/windows/base/) and [RStudio](https://posit.co/downloads/) for data manipulation
- [Slack](https://slack.com/) for communication
- [Lightshot](https://app.prntscr.com/en/index.html) for screenshots

## Setup
1. Install all the requirements on your system
2. Open up a terminal and clone this repository to a folder on your system:
    - `git clone https://github.com/bjoernhommel/<repository name>.git`
3. Install required python packages:
    - `pip install -r requirements.txt --quiet --disable-pip-version-check`

## Workflow

### General Workflow
Each contribution is referred to as `batch`. A batch consists of a mapping file (.json) and a data file (.parquet), if data exists.

1. Transcribe questionnaire meta-data to create `.json`-files; should be saved in the `./mappings` folder. See instructions in mapping schema below.
2. Save accompanying data files in the `./data` folder. Convert the original format to `.parquet` using the `covert_data_files.R` script.
    - Make sure that missing values are correctly coded as `NA`
    - Ensure that the `itemIds` in the corresponding mapping file aligns with the data file
3. Validate batches by running the validation script:
    - `python .\validation\validate_mappings.py`
    or run the automatically script:
    - `python .\validation\validate_mappings.py --auto --mapping_paths './mappings/' --data_paths './data'`