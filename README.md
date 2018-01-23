# PC to YNAB

__This project is no longer maintained.  The code was functional as of January 2016.  For a current and comprehensive alternative, please take a look at [bank2ynab](https://github.com/torbengb/bank2ynab)__

This program converts CSV export files of transactions from Personal Capital to the input format required for the desktop version of YNAB 4.

## Usage

To convert a Personal Capital export file into the YNAB import files, run:
`bundle exec ruby <personal_capital_export_filename>`

This will result in a series of files (by default, in `./ynab_imports`), in the proper YNAB 4 import format, split out by original accounts.

As of January 2016, the export file format was `MMM DD-YYYY thru MMM DD-YYYY transactions.csv`, for example `Dec 17-2015 thru Jan 15-2016 transactions.csv`.  The program doesn't care, as long as it can find the file.
