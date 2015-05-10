require 'smarter_csv'
require 'yaml'

# TODO: looks like we're approaching the point of making classes?
def load_config(config_file)
  YAML.load(File.open(config_file))
end

def quote_string(string)
  '"' + string + '"' unless string.nil?
end

# TODO: consider implementing optionparser or another command line args gem to make this a little better
# TODO: provide a helpful error in case it's not provided
input_file = ARGV[0]

# TODO: need to handle the absence of this file, maybe use a default? generate a sample?
config = load_config('config.yml')

key_mapping = {
  account: :account,
  date: :date,
  description: :payee,
  memo: :memo,
  amount: :amount
}

# TODO: more elegant way to print headers, perhaps from keys?
headers = ['Date','Payee','Category','Memo','Outflow','Inflow','Amount']

all_records = SmarterCSV.process(input_file, { key_mapping: key_mapping } )

# group whole collection by the account to split out by account files
# TODO: how does this handle an empty file?
accounts = all_records.group_by{ |rec| rec[:account] }

# reject any accounts not in the requested set
# TODO: if no whitelist provided, shouldn't we provided files for all?
accounts.select!{ |name, _| config['accounts'].include?(name) }

# TODO: find a better way to add line separation
accounts.each do |account_name, records|
  # TODO: create a directory if it doesn't exist
  # TODO: can you output a file with SmarterCSV as well?
  File.open("#{config['output_path']}/#{account_name}-transactions.csv",'w') do |file|
    file << headers.join(',') << "\n"
    records.each do |rec|
      file << Date.parse(rec[:date]).strftime('%m/%d/%Y') << ','
      file << quote_string(rec[:payee]) << ','
      file << ',' # PC categories don't map cleanly
      file << quote_string(rec[:memo]) << ','
      file << ',' # ignore outflow in preference to amount
      file << ',' # ignore inflow in preference to amount
      file << rec[:amount] << ','
      file << "\n"
    end
  end
end
