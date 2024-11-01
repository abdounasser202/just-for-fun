#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <version>"  # ./clone_odoo.sh 17.0
    echo "Example: $0 17.0"
    exit 1
fi

version=$1
repo_url="https://github.com/odoo/odoo.git"
target_dir="workspace/src/$version"

# Create the directory structure if it doesn't exist
mkdir -p workspace/src

# Clone into the specific directory
git clone -b $version --single-branch $repo_url $target_dir

if [ $? -eq 0 ]; then
    echo "Odoo version $version has been successfully cloned into '$target_dir'"
else
    echo "Failed to clone Odoo version $version. Please check if the version exists and try again."
fi