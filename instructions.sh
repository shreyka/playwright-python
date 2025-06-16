rm -rf dist/ build/ *.egg-info/
pip uninstall playwright

python -m build --wheel
pip install --force-reinstall dist/playwright-*.whl


## TEST
python -c "import playwright; print('Import successful')"
playwright --version