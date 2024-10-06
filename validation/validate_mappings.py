import os
import yaml
import json
import pandas as pd
import hashlib
import argparse
import logging
from tqdm import tqdm
from logging.handlers import RotatingFileHandler
from jsonschema import Draft7Validator
from prompt_toolkit import prompt
from prompt_toolkit.application import Application
from prompt_toolkit.layout import Layout, HSplit
from prompt_toolkit.widgets import Frame, TextArea, Label
from prompt_toolkit.key_binding import KeyBindings
from prompt_toolkit.styles import Style


class FileBrowser:
    def __init__(self, instructions='', show_files=True, show_dirs=True, file_extensions=None, current_path=None):

        if current_path is None:
            self.current_path = os.getcwd()
        elif os.path.isdir(current_path):
            self.current_path = current_path
        else:
            print(f"Invalid current_path '{current_path}'. Using current working directory.")
            self.current_path = os.getcwd()

        self.instructions = instructions
        self.selected_index = 0
        self.entries = []
        self.selected_items = set()
        self.show_files = show_files
        self.show_dirs = show_dirs
        self.file_extensions = file_extensions
        if self.file_extensions is not None:
            self.file_extensions = [ext.lower() for ext in self.file_extensions]
        self.max_visible_entries = 6
        self.view_top = 0
        self.build_ui()

    def build_ui(self):
        self.text_area = TextArea(focusable=False)
        self.update_entries()
        self.update_display()

        kb = KeyBindings()

        @kb.add('up')
        def move_up(event):
            if self.selected_index > 0:
                self.selected_index -= 1
                if self.selected_index < self.view_top:
                    self.view_top -= 1
                self.update_display()

        @kb.add('down')
        def move_down(event):
            if self.selected_index < len(self.entries) - 1:
                self.selected_index += 1
                if self.selected_index >= self.view_top + self.max_visible_entries:
                    self.view_top += 1
                self.update_display()
        
        @kb.add('space')
        def select_item(event):
            selected_entry = self.entries[self.selected_index]
            selected_path = os.path.abspath(os.path.join(self.current_path, selected_entry))
            if selected_path in self.selected_items:
                self.selected_items.remove(selected_path)
            else:
                self.selected_items.add(selected_path)
            self.update_display()

        @kb.add('right')
        @kb.add('left')
        def enter_directory(event):
            selected_entry = self.entries[self.selected_index]
            selected_path = os.path.join(self.current_path, selected_entry)
            if os.path.isdir(selected_path):
                self.current_path = os.path.abspath(selected_path)
                self.selected_index = 0
                self.view_top = 0
                self.update_entries()
                self.update_display()

        @kb.add('escape')
        @kb.add('enter')
        def confirm_selection(event):
            event.app.exit()


        container = HSplit([
            Label(text=self.instructions, style='fg:ansiblue'),
            Frame(
                body=self.text_area,
                title='File Browser (Use Up/Down arrow keys to navigate, Space to (de)select, Right/Left Arrow to enter directory, Enter to confirm selection)'
            )
        ])

        style = Style.from_dict({
            'frame.label': 'bold',
        })

        self.application = Application(
            layout=Layout(container),
            key_bindings=kb,
            style=style,
            full_screen=True
        )

    def update_entries(self):
        if self.current_path is None:
            self.current_path = os.getcwd()
        try:
            all_entries = os.listdir(self.current_path)
        except (PermissionError, TypeError) as e:
            all_entries = []
            print(f"Could not list directory '{self.current_path}': {e}")

        entries = []
        for entry in all_entries:
            full_path = os.path.join(self.current_path, entry)
            if os.path.isdir(full_path) and self.show_dirs:
                entries.append(entry)
            elif os.path.isfile(full_path) and self.show_files:
                if self.file_extensions is None:
                    entries.append(entry)
                else:
                    file_ext = os.path.splitext(entry)[1].lower()
                    if file_ext in self.file_extensions:
                        entries.append(entry)
        entries = sorted(entries)
        if self.show_dirs and os.path.dirname(self.current_path) != self.current_path:
            entries = ['..'] + entries  # Include parent directory if not at root
        self.entries = entries

    def update_display(self):
        display_text = []
        visible_entries = self.entries[self.view_top:self.view_top + self.max_visible_entries]
        for idx, entry in enumerate(visible_entries):
            actual_idx = self.view_top + idx  # Adjust for the actual index in the full list
            full_path = os.path.abspath(os.path.join(self.current_path, entry))
            selected_marker = '[x]' if full_path in self.selected_items else '[ ]'
            pointer = '>' if actual_idx == self.selected_index else ' '
            line = f"{pointer} {selected_marker} {entry}"
            display_text.append(line)
        self.text_area.text = '\n'.join(display_text)

    def run(self):
        self.application.run()
        selected_paths = list(self.selected_items)
        return selected_paths


class UserMenu:
    def __init__(self, prompt, options):
        self.prompt = prompt
        self.options = options
        self.selected_index = 0
        self.build_ui()

    def build_ui(self):
        self.text_area = TextArea(focusable=False)
        self.update_display()

        kb = KeyBindings()

        @kb.add('up')
        def move_up(event):
            if self.selected_index > 0:
                self.selected_index -= 1
                self.update_display()

        @kb.add('down')
        def move_down(event):
            if self.selected_index < len(self.options) - 1:
                self.selected_index += 1
                self.update_display()

        @kb.add('enter')
        def select_option(event):
            event.app.exit(result=self.selected_index)

        @kb.add('escape')
        def select_option(event):
            event.app.exit(result=None)

        container = HSplit([
            #TextArea(text=self.prompt + '\n', style='bold', focusable=False),
            Label(text=self.prompt, style='fg:ansiblue'),
            self.text_area
        ])

        style = Style.from_dict({
            'frame.label': 'bold',
            'selected': 'reverse',
        })

        self.application = Application(
            layout=Layout(container),
            key_bindings=kb,
            style=style,
            full_screen=False
        )

    def update_display(self):
        display_text = []
        for idx, option in enumerate(self.options):
            pointer = '>' if idx == self.selected_index else ' '
            line = f"{pointer} {option}"
            display_text.append(line)
        self.text_area.text = '\n'.join(display_text)

    def run(self):
        result = self.application.run()
        return result

def setup_logger(name, config, level=logging.INFO):
    logging_path = config['logging_path']

    log_dir = os.path.dirname(logging_path)
    if not os.path.exists(log_dir):
        os.makedirs(log_dir)

    formatter = logging.Formatter('%(asctime)s %(levelname)s %(message)s')

    logger = logging.getLogger(name)
    logger.setLevel(level)

    # Check if handlers already exist
    if not logger.handlers:
        handler = RotatingFileHandler(logging_path, maxBytes=2000000, backupCount=5)
        handler.setFormatter(formatter)
        logger.addHandler(handler)

        # Add StreamHandler to print logs to console
        console_handler = logging.StreamHandler()
        console_handler.setFormatter(formatter)
        logger.addHandler(console_handler)

    return logger

def validate_paths(mapping_paths, data_paths):

    logger = setup_logger('preparation', config)

    def check_duplicate_filenames(file_paths):
        filenames = [os.path.basename(path) for path in file_paths]
        duplicates = set([name for name in filenames if filenames.count(name) > 1])

        if duplicates:
            try:
                raise ValueError(f"Duplicate filenames found {', '.join(duplicates)}")
            except Exception as e:
                logger.error(f'Error: {str(e)}')

        return file_paths

    def get_file_paths(paths_list, file_extensions):
        results = []

        for path in paths_list:
            if os.path.isfile(path) and path.endswith(tuple(file_extensions)):
                results.append(path)
            elif os.path.isdir(path):
                for root, _, files in os.walk(path):
                    for file in files:
                        if file.endswith(tuple(file_extensions)):
                            results.append(os.path.join(root, file))

        return check_duplicate_filenames(results)

    def match_paths(mapping_paths, data_paths):

        # Create a dictionary mapping base filenames to their full paths for mapping_paths
        mapping_basenames = {}
        for path in mapping_paths:
            base = os.path.basename(path)
            name, _ = os.path.splitext(base)
            mapping_basenames[name] = path

        # Create a dictionary mapping base filenames to their full paths for data_paths
        data_basenames = {}
        for path in data_paths:
            base = os.path.basename(path)
            name, _ = os.path.splitext(base)
            data_basenames[name] = path

        # Find matching basenames and collect results
        results = []
        for name in mapping_basenames:
            mapping_path = mapping_basenames[name]
            data_path = data_basenames.get(name, None)
            results.append((mapping_path, data_path))

        # Issue warnings for any data_paths that do not have a corresponding mapping_path
        for name in data_basenames:
            if name not in mapping_basenames:
                logger.warning(f'Warning: Base filename `{name}` in data_paths is not present in mapping_paths.')

        return results

    full_mapping_paths = get_file_paths(mapping_paths, ['.json'])
    full_data_paths = get_file_paths(data_paths, ['.parquet'])

    batched_paths = match_paths(full_mapping_paths, full_data_paths)

    return batched_paths

def validate_files(batched_paths, config, force_revalidation=False, confirm_prompts=False):

    class UnderinclusiveDeclarationError(Exception):
        pass

    class OverinclusiveDeclarationError(Exception):
        pass

    def hash_batch(mapping_data, df=None):

        mapping_dump = json.dumps(mapping_data, sort_keys=True).encode('utf-8')
        mapping_hash = hashlib.sha256(mapping_dump).hexdigest()

        if df is None:
            return mapping_hash

        data_dump = json.dumps(df.astype(str).to_dict(), sort_keys=True).encode('utf-8')
        data_hash = hashlib.sha256(data_dump).hexdigest()
        batch_dump = (mapping_hash + data_hash).encode('utf-8')

        return hashlib.sha256(batch_dump).hexdigest()

    def validate_cache(hash, batch_id, cache):
        try:
            cached_record = cache.query(f'id == "{batch_id}"').iloc[0,:]
            return str(hash) == (cached_record.hash)
        except:
            return False

    def validate_mapping_data(mapping_data, validator, batch_id, config):

        def filter_errors(errors, exceptions):
            filtered_errors = []
            for error in errors:
                error_path = list(error.absolute_path)
                if any(
                    len(error_path) >= len(exc_path := exception.get('path', [])) and
                    all(
                        ex in ('*', None) or str(ep) == str(ex)
                        for ep, ex in zip(error_path, exc_path)
                    )
                    for exception in exceptions
                ):
                    # log here
                    pass

                else:
                    filtered_errors.append(error)
            return filtered_errors

        errors = sorted(validator.iter_errors(mapping_data), key=lambda e: e.path)
        exceptions = config.get('exceptions', {}).get(batch_id, [])

        return filter_errors(errors, exceptions)

    def validate_item_ids(mapping_data, df):
        item_ids = []
        for instrument in mapping_data['instruments']:
            for item in instrument['items']:
                item_ids.append(item['itemId'])
        return df[item_ids]

    def validate_scale_concurrence(mapping_data):

        item_ids = []
        for instrument in mapping_data['instruments']:
            for item in instrument['items']:
                item_ids.append(item['itemId'])

        for instrument in mapping_data['instruments']:
            for scale in instrument["scales"]:

                scale_name = scale['scaleName']
                scale_items = scale["lowerItemIds"] + scale["upperItemIds"]

                if not set(scale_items).issubset(item_ids):
                    missing_ids = set(scale_items) - set(item_ids)
                    raise KeyError(f'itemIds in scale `{scale_name}` not it `items`: {missing_ids}')

    def validate_response_formats(mapping_data, df):

        items = pd.DataFrame(
            data=[item for instrument in mapping_data['instruments'] for item in instrument['items']]
        )
        response_formats = pd.DataFrame(mapping_data['responseFormats'])

        mapping_ranges = (
            pd.merge(left=items, right=response_formats, on="responseFormatId")
            .loc[:, ['responseFormatId', 'itemId', 'minValue', 'maxValue']]
            .rename(columns={'minValue': 'minMappedValue', 'maxValue': 'maxMappedValue'})
            .assign(mappedRange=lambda df: df['maxMappedValue'] - df['minMappedValue'])
        )

        empirical_ranges = (
            df
            .agg(['min', 'max', 'size', 'mean', 'std']).T
            .assign(itemSkew=lambda x: df.skew())
            .assign(itemKurt=lambda x: df.kurt())
            .reset_index()
            .rename(
                columns={
                    'index': 'itemId',
                    'min': 'minEmpiricalValue',
                    'max': 'maxEmpiricalValue',
                    'mean': 'itemMean',
                    'std': 'itemSd',
                    'size': 'sampleSize',
                }
            )
            .assign(empiricalRange=lambda df: df['maxEmpiricalValue'] - df['minEmpiricalValue'])
        )

        range_deviations = (
            pd
            .merge(left=mapping_ranges, right=empirical_ranges, on='itemId')
            .assign(rangeDeviations=lambda df: df['empiricalRange'] - df['mappedRange'])
            .query('rangeDeviations != 0')
        )
        item_count = empirical_ranges.shape[0]

        underinclusive_columns = ['responseFormatId', 'itemId', 'empiricalRange', 'mappedRange']
        underinclusive_ranges = range_deviations.query('rangeDeviations > 0').loc[:, underinclusive_columns]
        if not underinclusive_ranges.empty:
            raise UnderinclusiveDeclarationError(f"""
                Underinclusive range declaration of response formats
                ({underinclusive_ranges.shape[0]} out of {item_count} itemIds). \n
                {underinclusive_ranges}
            """)

        overinclusive_columns = underinclusive_columns + ['itemMean', 'itemSd', 'sampleSize', 'itemSkew']
        overinclusive_ranges = range_deviations.query('rangeDeviations < 0').loc[:, overinclusive_columns]
        if not overinclusive_ranges.empty:
            raise OverinclusiveDeclarationError(f"""
                Overinclusive range declaration of response formats.
                ({overinclusive_ranges.shape[0]} out of {item_count} itemIds). \n
                {overinclusive_ranges}
            """)

        return None

    def declare_valid(cache, batch_id, batch_hash, config, logger):
        cache.loc[batch_id, 'hash'] = batch_hash
        cache.reset_index().to_json(path_or_buf=config['cache_path'], indent=4)
        logger.info(f'Validated: {batch_id}')

    logger = setup_logger('validation', config)

    batched_paths_tqdm = tqdm(
        iterable=batched_paths,
        desc='Validating'
    )

    ignored_batch_ids = config['to_ignore']

    with open(config['schema_path'], 'r', encoding='utf-8') as schema_file:
        schema = json.load(schema_file)

    validator = Draft7Validator(schema)

    try:
        cache = pd.read_json(config['cache_path']).set_index('id')
    except Exception as e:
        cache = pd.DataFrame(columns=['id', 'hash']).set_index('id')

    logger.info(f"{'-'*30}Validation Start{'-'*30}")
    logger.info(f'Initializing validation of {len(batched_paths)} batches.')
    for batched_path in batched_paths_tqdm:

        df = None
        mapping_path, data_path = batched_path

        batch_id = os.path.basename(mapping_path).split('.')[0]

        if ignored_batch_ids:
            if batch_id in ignored_batch_ids:
                logger.info(f'Skipping `{batch_id}`: Batch was declared to be ignored in config.yaml')
                continue

        try:
            with open(mapping_path, 'r', encoding='utf-8') as json_file:
                mapping_data = json.load(json_file)
        except Exception as e:
            logger.error(f'Error in `{batch_id}`: Failed to load mapping file! {str(e)}')
            break

        try:
            df = pd.read_parquet(data_path)
            batch_hash = hash_batch(mapping_data, df)
        except TypeError as e:
            logger.warning(f'Warning in `{batch_id}`: Missing data file; please check if this is intended!')
            batch_hash = hash_batch(mapping_data)
        except Exception as e:
            logger.error(f'Error in `{batch_id}`: Failed load data file ({data_path})! {str(e)}')
            break

        is_valid = validate_cache(batch_hash, batch_id, cache)
        if is_valid:
            if force_revalidation:
                logger.info(f'Forcing re-validation of `{batch_id}`.')
            else:
                logger.info(f'Skipping `{batch_id}`: File(s) have not been modified since last validation!')
                continue

        schema_errors = validate_mapping_data(mapping_data, validator, batch_id, config)
        if schema_errors:
            for validation_error in schema_errors:
                error_path = '.'.join(map(str, validation_error.absolute_path))
                schema_path = '.'.join(map(str, validation_error.absolute_schema_path))
                logger.error(f'Error in `{batch_id}`: Validation of mapping failed! {str(validation_error.message)}')
                if len(error_path) > 0:
                    logger.error(f'Error path in mapping: {error_path}')
                    logger.error(f'Schema path: {schema_path}')
            break

        if df is None:
            declare_valid(cache, batch_id, batch_hash, config, logger)
            continue

        try:
            df = validate_item_ids(mapping_data, df)
        except KeyError as e:
            logger.error(f'Error in `{batch_id}`: Mapping contains variables which cannot be found in data! {str(e)}')
            break
        except Exception as e:
            logger.error(f'Error in `{batch_id}`: {str(e)}')
            break

        try:
            validate_scale_concurrence(mapping_data)
        except Exception as e:
            logger.error(f'Error in `{batch_id}`: Possible missmatch between itemIds in scales and items: {str(e)}')
            break

        try:
            validate_response_formats(mapping_data, df)
        except UnderinclusiveDeclarationError as e:
            logger.error(f'Error in `{batch_id}`: {str(e)}')
            break
        except OverinclusiveDeclarationError as e:
            logger.warning(f'Warning in `{batch_id}`: {str(e)}')
            if not confirm_prompts:
                prompt_text = """
                Please examine the discrepancies in the ranges between the empirical
                data and the declared response format declare in mapping.
                Do you confirm that the mapped ranges for ALL items in the table are valid? [Y/n]:
                """
                response = prompt(prompt_text)
                if response.lower() in ('', 'y', 'yes'):
                    logger.info(f'Warning was manually ignored in `{batch_id}`: {str(e)}')
                else:
                    logger.error(f'Error in `{batch_id}`: {str(e)}')
                    break

        declare_valid(cache, batch_id, batch_hash, config, logger)
    else:
        logger.info(f'Success: All files valid! Happy days!')
    logger.info(f"{'-'*30}Validation End{'-'*30}")

def launch_interactive_mode(config):

    # validation_mode_menu
    validation_mode_menu = UserMenu(
        prompt="Please choose an option:",
        options=[
            'automatic validation',
            'manual validation',
        ]
    )
    validation_mode_index = validation_mode_menu.run()

    if validation_mode_index == 0:
        validation_mode = 'automatic'
    elif validation_mode_index == 1:
        validation_mode = 'manual'
    else:
        print('Quitting.')
        return

    # browser_menu
    if validation_mode == 'automatic':
        batched_paths = validate_paths(config['mapping_paths'], config['data_paths'])
    else:
        mapping_browser_menu = FileBrowser(
            instructions="Select folders and/or individual .json-files to validate",
            show_files=True,
            show_dirs=True,
            file_extensions=['.json']
        )
        mapping_paths = mapping_browser_menu.run()

        data_browser_menu = FileBrowser(
            instructions="Now select folders and/or corresponding .parquet files",
            show_files=True,
            show_dirs=True,
            file_extensions=['.parquet']
        )
        data_paths = data_browser_menu.run()

        batched_paths = validate_paths(mapping_paths, data_paths)

    # force_revalidation_menu
    force_revalidation_menu = UserMenu(
        prompt="Force re-validation of previously validated files?",
        options=[
            'no',
            'yes',
        ]
    )
    force_revalidation_index = force_revalidation_menu.run()

    if force_revalidation_index == 0:
            force_revalidation = False
    elif force_revalidation_index == 1:
            force_revalidation = True
    else:
        print('quitting')
        return

    validate_files(batched_paths, config, force_revalidation)

if __name__ == '__main__':

    parser = argparse.ArgumentParser()
    parser.add_argument(
        '--auto',
        action='store_true',
        help="Run the script with config settings without UI.",
        required=False
    )

    parser.add_argument(
        '--force',
        action='store_true',
        help="Ignore cache and force re-validation of all files.",
        required=False
    )

    parser.add_argument(
        '--confirm',
        action='store_true',
        help="Automatically confirm all prompts.",
        required=False
    )
    
    parser.add_argument(
        '--mapping_paths',
        nargs='+',
        type=str,
        help='An array paths to mapping files'
    )
    
    parser.add_argument(
        '--data_paths',
        nargs='+',
        type=str,
        help='An array paths to data files'
    )

    args = parser.parse_args()

    script_dir = os.path.dirname(os.path.abspath(__file__))
    config_path = os.path.join(script_dir, 'config.yaml')
    
    with open(config_path, 'r') as file:
        config = yaml.safe_load(file)

    if args.auto:
        
        if args.mapping_paths and args.data_paths:

            batched_paths = validate_paths(args.mapping_paths, args.data_paths)
            from pprint import pprint
        else:
            batched_paths = validate_paths(config['mapping_paths'], config['data_paths'])

        force_revalidation = True if args.force else False
        confirm_prompts = True if args.confirm else False
        validate_files(batched_paths, config, force_revalidation, confirm_prompts)
    else:
        launch_interactive_mode(config)