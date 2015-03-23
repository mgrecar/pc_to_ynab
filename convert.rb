require 'smarter_csv'

# TODO: consider implementing optionparser or another command line args gem to make this a little better
input_file = ARGV[0]

key_mapping = {
  account: :account,
  date: :date,
  description: :payee,
  memo: :memo,
  amount: :amount
}

# TODO: make this configurable, somehow
account_names = [
  'Capital One 360 Savings',
  'Key Checking',
  'Capital One CC'
]

# TODO: more elegant way to print headers, perhaps from keys?
headers = ['Date','Payee','Category','Memo','Outflow','Inflow','Amount']

all_records = SmarterCSV.process(input_file, { key_mapping: key_mapping } )

# group whole collection by the account to split out by account files
accounts = all_records.group_by{ |rec| rec[:account] }

# reject any accounts not in the requested set
accounts.select!{ |name, _| account_names.include?(name) }

# TODO: find a better way to add line separation
accounts.each do |account_name, records|

# TODO: provide a command line arg or configuration for destination of files
File.open("/Users/mattgrecar/Downloads/ynab_imports/#{account_name}-transactions.csv",'w') do |file|
    file << headers.join(',') << "\n"
    records.each do |rec|
      file << Date.parse(rec[:date]).strftime('%m/%d/%Y') << ','
      file << rec[:payee] << ','
      file << ',' # PC categories don't map cleanly
      file << rec[:memo] << ','
      file << ',' # ignore outflow in preference to amount
      file << ',' # ignore inflow in preference to amount
      file << rec[:amount] << ','
      file << "\n"
    end
  end
end
