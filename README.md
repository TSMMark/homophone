# Homophones on Homophone.com
## The Internet's only complete homophone list.

**production app:** https://www.homophone.com

**staging app:** https://homophonestaging.herokuapp.com

www.homophone.com Copyright Alfred Aloisi 2017

# Development

## Setup

### Application config

Duplicate the example `application.SAMPLE.yml` file and add real values.

```
$ cp config/application.SAMPLE.yml config/application.yml
$ vim config/application.yml
```

### Docker

```
$ yarn docker-build
$ yarn docker-ssh
```

### Database

In docker:

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

In docker:

```
$ rails s
```

Or from host OS:

```
$ yarn server
```

```
$ yarn console
```

# Deploying

## Setup heroku CLI locally

https://devcenter.heroku.com/articles/heroku-cli#download-and-install

Make sure to log in to your heroku account that has access to `homophone` app

```
$ heroku login
```

## Set up heroku git remotes one time. 

Add homophone heroky app as a git remote

```
$ heroku git:remote -a homophone
```

Rename the git remote to `production`

```
$ git remote rename heroku production
```

Now you can deploy by pushing to that remote branch:

### Production

First, make sure you have checked out master locally so you are deploying the latest.

```
$ git checkout master
```

Now push local `master` to remote `master` on the heroku remote called `production`

```
$ git push production master
```

#### Advanced (probably shouldn't do this on production!)

To deploy a local branch other than `master`, push your local branch name to the remote `master`

```
$ git push production my-local-branch:master
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
