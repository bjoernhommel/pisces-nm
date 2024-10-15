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
1. Install all the requirements mentioned above on your system
2. Open up a terminal and clone this repository to a folder on your system:
    ```
    git clone https://github.com/bjoernhommel/<repository name>.git
    ```
3. Install required python packages
    ```
    pip install -r requirements.txt --quiet --disable-pip-version-check
    ```

## Workflow

### General Workflow
Each contribution is referred to as a `batch`. A batch always consists of meta data, a so called mapping file (.json). Batches can also include empirical data, saved as `.parquet`-files.

1. Synchronize changes that may have occured recently. Open the terminal (either in Visual Studio code or your operating system):
    ```
    git fetch
    git pull origin main
    ```
2. Use the Google Sheet on [work packages](https://docs.google000.com/spreadsheets/d/1FFwb4xN-BeSiqqDHpVWP9OOnE5okpUHMwsAkBqjN2so/edit#gid=0) which contains an overview of all batches that need to be completed.
3. Assign yourself to a `work_package_id` (work package = batch) by using the dropdown `assigned_to`. If the questionnaire/survey has accompanying data, set `has_data_repository` to `TRUE` in the Google Sheet.
4. Make a copy of `example.json` in your `./mappings` folder and renamed it to match the work package / batch you're working on.
5. Transcribe the meta-data of the respective survey or questionnaire to the newly created `.json` file, according to the **mapping schema** (see corresponding section below) using Visual Studio Code.
6. If the batch/work package has accompanying data, save it locally into your `./data` folder. Use the `covert_data_files.R` script to...
    - ...ensure that missing values are correctly coded as `NA`.
    - ...ensure that the `itemIds` in the corresponding mapping file align with the variables in the data file.
    - ...convert the original format to `.parquet` (for example from .csv).
7. Delete the **original** data file (never delete `.parquet` files).
8. Validate batches by running the validation script in the Visual Studio Code terminal:
    ```
    python .\validation\validate_mappings.py
    ```
    or run the script automatically:
    ```
    python .\validation\validate_mappings.py --auto --mapping_paths './mappings/' --data_paths './data'
    ```
    The script will inform you if validation succeeded. If validation fails, pay attention to the error message and fix the corrsponding batch by editing the `.json` and/or `.parquet` file. In that case, re-run the validation script until validation succeeds.
9. Add, commit and push your changes:
    ```
    git status
    git add -A
    git commit -m <message>
    ```
    Whereas `git add -A` adds all files that you have edited, you can also add individual files by `git add <filename>`. Make sure that `<message>` briefly describes your update.
10. Mark completed work packages in the `complete` column in `backlog_digital` or  `backlog_analog`
11. Log your working hours in your personal Google Sheet when you are done for the day
    - Enter your working hours for the day
    - Briefly describe the tasks you have been working on
    - Enter the number of work packages you have completed


#### Creating mappings of questionnaires and surveys (.json-files)
Mapping Schema Properties:

##### Root Object
- `_comment` (string, null): Optional comment field.
- `contentType` (string): Must be "self-report".
- `datasetFilename` (string, null): Name of the dataset file. Must have a `.parquet` extension if specified.
- `datasetUrl` (string, null): URL of the dataset if available.
- `datasetIsbn` (string, null): ISBN of the dataset if available.
- `datasetDoi` (string, null): DOI of the dataset if available.
- `datasetApaReference` (string, null): APA reference of the dataset if available.
- `datasetApaCitation` (string, null): APA citation for the dataset.
##### Response Formats
- `responseFormatId` (string): Unique identifier for the response format.
- `responseFormatType` (string): Either "rating scale" or "single choice".
- `responseFormatDataType` (string): The data type of the response values (e.g., "integer", "string", "float").
- `responseFormatMinValue` (number): Minimum value for the response (e.g., 1).
- `responseFormatMaxValue` (number): Maximum value for the response (e.g., 6).
- `responseFormatIncrementValue` (number): The increment between values (e.g., 1).
- `responseFormatLabels` (object): Describes what each value represents. Key should be a string representing a number (e.g., "1": "Very Inaccurate").
##### Instruments
- `instrumentName` (string, null): Full name of the instrument.
- `instrumentNameShort` (string, null): Short name of the instrument.
- `instrumentLanguage` (string): Language code of the instrument, either "en" for English or "de" for German.
- `instrumentUrl` (string, null): URL to the instrument, if available.
- `instrumentIsbn` (string, null): ISBN for the instrument, if available.
- `instrumentDoi` (string, null): DOI for the instrument, if available.
- `instrumentApaReference` (string, null): APA reference for the instrument.
- `instrumentApaCitation` (string, null): APA citation for the instrument.
- `instrumentIsProprietary` (bool): `true` if the instrument and items are copyrighted or should not be distributed; else `false`
##### Scales
Each `instrument` may contain multiple scales:
- `scaleName` (string): Name of the scale (e.g., "Agreeableness").
- `scaleDefinitionText` (string, null): A short definition of the scale. **Ignore this property for now!**
- `lowerItemIds` (array): An array of item IDs that fall in the lower range of this scale. These item IDs should correspond to the item objects under the `items` property. For example, if the scale is "Agreeableness", the item (`A1`) "_I am indifferent to the feelings of others._" is indicating **low agreeableness**. Hence, the coding should be: `"lowerItemIds": [ "A1", ...]`
- `upperItemIds` (array): An array of item IDs that fall in the upper range of this scale. These item IDs should correspond to the item objects under the items property. For example, if the scale is "Agreeableness", the item (`A2`) "_I inquire about others' well-being._" is indicating **high agreeableness**. Hence, the coding should be Hence, the coding should be: `"upperItemIds": [ "A2", ...]`
- `scaleLowerFeedbackText` (string, null): Feedback text for lower scores, if available. **Ignore this property for now!**
- `scaleUpperFeedbackText` (string, null): Feedback text for upper scores, if available. **Ignore this property for now!**
- `scaleFeedbackTexts` (array, null): Optional array of additional feedback texts. **Ignore this property for now!**
##### Subsets
Each `instrument` may also have subsets:
- `subsetName` (string): Name of the subset.
- `subsetDescription` (string, null): Description of the subset.
- `subsetItemIds` (array or string): An array of item IDs in the subset or "*" to include all items.
- `scaleStatistics` (array, null): An optional array of statistics for scales in the subset, such as the mean and standard deviation for each scale.
**For now, subsets may be coded as follows**:
```
            "subsets": [
                {
                    "subsetName": "Standard Version",
                    "subsetDescription": null,
                    "subsetItemIds": "*",
                    "scaleStatistics": null
                }
            ],
```
##### Items
Each instrument must include items:
- `itemId` (string): A unique identifier for the item.
- `itemStemText` (string): The question or statement text for the item.
- `responseFormatId` (string): The ID of the response format used for this item.