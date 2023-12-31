#!/bin/bash
sec_secret_storage_loc="../my_secret_files/iss-watcher"

echo "Script for preparing the development environment"
echo "------------------------------------------------"

echo "Checking if config.ini exists in the current working dir -->"
if test -f "config.ini"; then
    echo "exists"
else
	echo "Copying config file from secure secret storage"
	cp $HOME$sec_secret_storage_loc/config.ini .
	if [ $? -eq 0 ]; then echo "OK"; else echo "Problem copying config.ini file"; exit 1; fi
fi
echo "------------------------------------------------"

echo "Checking if log_main.yaml exists in the current working dir -->"
if test -f "log_main.yaml"; then
    echo "exists"
else
	echo "Copying log config file from local dev template log_main.yaml.dev"
	cp log_main.yaml.dev log_main.yaml
	if [ $? -eq 0 ]; then echo "OK"; else echo "Problem copying log_main.yaml file"; exit 1; fi
fi
echo "------------------------------------------------"

echo "Checking if log_migrate_db.yaml exists in the current working dir -->"
if test -f "log_migrate_db.yaml"; then
    echo "exists"
else
	echo "Copying log config file from local dev template log_migrate_db.yaml.dev"
	cp log_migrate_db.yaml.dev log_migrate_db.yaml
	if [ $? -eq 0 ]; then echo "OK"; else echo "Problem copying log_migrate_db.yaml file"; exit 1; fi
fi
echo "------------------------------------------------"

echo "Getting python executable loc"
python_exec_loc=$(which python)
if [ $? -eq 0 ]; then echo "OK"; else echo "Problem getting python exec location"; exit 1; fi
echo "$python_exec_loc"
echo "------------------------------------------------"

echo "Running config tests"
$python_exec_loc tests/test_config.py
if [ $? -eq 0 ]; then echo "OK"; else echo "Configuration test FAILED"; exit 1; fi
echo "------------------------------------------------"

echo "Running DB migrations"
$python_exec_loc migrate_db.py
if [ $? -eq 0 ]; then echo "OK"; else echo "DB migration FAILED"; exit 1; fi
echo "------------------------------------------------"

echo "Running test_main_get_osm_search_coords EXAMPLE test"
$python_exec_loc tests/test_main_get_osm_search_coords.py
if [ $? -eq 0 ]; then echo "OK"; else echo "Worker test FAILED"; exit 1; fi
echo "------------------------------------------------"

echo "ALL SET UP! YOU ARE READY TO CODE"
echo "to start the program, execute:"
echo "$python_exec_loc main.py"
