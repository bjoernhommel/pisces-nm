# Python Scripts

## Validation
Running `validate_mappings.py` in either:
- User Interface (UI): `python .\py\validation\validate_mappings.py`
- Command line interface (CLI): `python .\py\validation\validate_mappings.py --auto`

Arguments for CLI:
- `--auto` skip the UI, automatically processing with `config.yaml` settings
- `--force` force re-validation of previously validated files
- `--confirm` confirm all prompts and checks during validation
- `--mapping_paths` specify mapping paths
- `--data_paths` specify data paths

Examples:
- `python .\validation\validate_mappings.py --auto --mapping_paths './mappings/' --data_paths './data'`


