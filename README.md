# Homophone.com
## The Internet's only complete homophone list.

**production app:** http://www.homophone.com

**staging app:** http://homophonestaging.herokuapp.com

www.homophone.com Copyright Alfred Aloisi 2017

# Development

## Setup

### Application config

Duplicate the example `application.SAMPLE.yml` file and add real values.

```
$ cp config/application.SAMPLE.yml config/application.yml
$ vim config/application.yml
```

### Database

Install and start postgresql. http://postgresapp.com is fine but you can use
whatever.

Once postgresql is installed anr running setup the database.

```
$ rake db:setup
```

### Custom local domain

Add `homophone-localhost.com` to `/etc/hosts` pointing to localhost

```
$ sudo vim /etc/hosts
```

Add a line that looks like

```
127.0.0.1 homophone-localhost.com
```

### Web server

```
$ rails s
```

# Deploying

Set up heroku git remotes one time. Now you can deploy by pushing to those
remote branches.

### Staging

```
$ git push staging master
```

### Staging

```
$ git push production master
```

### Use figaro to set the environment variables.

```
$ figaro heroku:set -e staging -a homophonestaging
$ figaro heroku:set -e production -a homophone
```

# Importing Homophones CSV

The CSV should have 4 columns: word_id, text, spelling, relation_id

__Important__: Make sure the CSV rows are oredered by relation_id.

Save the CSV to `lib/assets/homophone_list.csv`

Run the rake task.

```
$ rake db:import
```
