# Homophone.com v2
## The Internet's only complete homophone list.

**old (current) site:** http://www.homophone.com

**staging app:** http://homophonestaging.herokuapp.com

www.homophone.com Copyright Alfred Aloisi 2014

# Deploying

### Use figaro to set the environment variables.
```
$ figaro heroku:set -e staging -a homophonestaging
$ figaro heroku:set -e production -a homophone
```

# Importing Homphones CSV

The CSV should have 4 columns: word_id, text, spelling, relation_id

__Important__: Make sure the CSV rows are oredered by relation_id.

Save the CSV to `lib/assets/homophone_list.csv`

Run the rake task.
```
$ rake db:import
```
