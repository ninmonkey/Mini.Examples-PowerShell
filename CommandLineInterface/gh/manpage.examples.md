# Manual Examples

see: summary of all commands on one page [https://cli.github.com/manual/gh_help_reference](https://cli.github.com/manual/gh_help_reference)


- [Manual Examples](#manual-examples)
  - [`gh repo` Top ↑](#gh-repo-top-)
    - [Examples](#examples)
    - [Args](#args)
  - [`gh gist create` Top ↑](#gh-gist-create-top-)
    - [Examples](#examples-1)
    - [Args](#args-1)
  - [`gh browse` Top ↑](#gh-browse-top-)
    - [Examples](#examples-2)
    - [Args](#args-2)
  - [`gh api` Top ↑](#gh-api-top-)
    - [Examples](#examples-3)
    - [Args](#args-3)
  - [`gh gist` Top ↑](#gh-gist-top-)
    - [Examples](#examples-4)
    - [Args](#args-4)

## `gh repo` [Top ↑](#manual-examples)


### Examples

```sh
$ gh repo create
$ gh repo clone cli/cli
$ gh repo view --web
```

### Args
..

## `gh gist create` [Top ↑](#manual-examples)

### Examples

```sh
# publish file 'hello.py' as a public gist
$ gh gist create --public hello.py

# create a gist with a description
$ gh gist create hello.py -d "my Hello-World program in Python"

# create a gist containing several files
$ gh gist create hello.py world.py cool.txt

# read from standard input to create a gist
$ gh gist create -

# create a gist from output piped from another command
$ cat cool.txt | gh gist create
```

### Args

```sh
  -d, --desc string       A description for this gist
  -f, --filename string   Provide a filename to be used when reading from STDIN
  -p, --public            List the gist publicly (default: secret)
  -w, --web               Open the web browser with created gist
```

## `gh browse` [Top ↑](#manual-examples)

### Examples

```sh
$ gh browse
#=> Open the home page of the current repository

$ gh browse 217
#=> Open issue or pull request 217

$ gh browse --settings
#=> Open repository settings

$ gh browse main.go:312
#=> Open main.go at line 312

$ gh browse main.go --branch main
#=> Open main.go in the main branch
```

### Args

```sh
-b, --branch string            Select another branch by passing in the branch name
-n, --no-browser               Print destination URL instead of opening the browser
-p, --projects                 Open repository projects
-R, --repo [HOST/]OWNER/REPO   Select another repository using the [HOST/]OWNER/REPO format
-s, --settings                 Open repository settings
-w, --wiki                     Open repository wiki
```

## `gh api` [Top ↑](#manual-examples)

[https://cli.github.com/manual/gh_api](https://cli.github.com/manual/gh_api)
 
### Examples

```sh
# list releases in the current repository
$ gh api repos/{owner}/{repo}/releases

# post an issue comment
$ gh api repos/{owner}/{repo}/issues/123/comments -f body='Hi from CLI'

# add parameters to a GET request
$ gh api -X GET search/issues -f q='repo:cli/cli is:open remote'

# set a custom HTTP header
$ gh api -H 'Accept: application/vnd.github.v3.raw+json' ...

# opt into GitHub API previews
$ gh api --preview baptiste,nebula ...

# print only specific fields from the response
$ gh api repos/{owner}/{repo}/issues --jq '.[].title'

# use a template for the output
$ gh api repos/{owner}/{repo}/issues --template \
  ' ()\n'

# list releases with GraphQL
$ gh api graphql -F owner='{owner}' -F name='{repo}' -f query='
  query($name: String!, $owner: String!) {
    repository(owner: $owner, name: $name) {
      releases(last: 3) {
        nodes { tagName }
      }
    }
  }
'

# list all repositories for a user
$ gh api graphql --paginate -f query='
  query($endCursor: String) {
    viewer {
      repositories(first: 100, after: $endCursor) {
        nodes { nameWithOwner }
        pageInfo {
          hasNextPage
          endCursor
        }
      }
    }
  }
'
```

### Args

```sh
      --cache duration        Cache the response, e.g. "3600s", "60m", "1h"
  -F, --field key=value       Add a typed parameter in key=value format
  -H, --header key:value      Add a HTTP request header in key:value format
      --hostname string       The GitHub hostname for the request (default "github.com")
  -i, --include               Include HTTP response headers in the output
      --input file            The file to use as body for the HTTP request
  -q, --jq string             Query to select values from the response using jq syntax
  -X, --method string         The HTTP method for the request (default "GET")
      --paginate              Make additional HTTP requests to fetch all pages of results
  -p, --preview strings       Opt into GitHub API previews
  -f, --raw-field key=value   Add a string parameter in key=value format
      --silent                Do not print the response body
  -t, --template string       Format the response using a Go template
```

## `gh gist` [Top ↑](#manual-examples)

### Examples

```sh
# publish file 'hello.py' as a public gist
$ gh gist create --public hello.py

# create a gist with a description
$ gh gist create hello.py -d "my Hello-World program in Python"

# create a gist containing several files
$ gh gist create hello.py world.py cool.txt

# read from standard input to create a gist
$ gh gist create -

# create a gist from output piped from another command
$ cat cool.txt | gh gist create
```

### Args

```sh
  -d, --desc string       A description for this gist
  -f, --filename string   Provide a filename to be used when reading from STDIN
  -p, --public            List the gist publicly (default: secret)
  -w, --web               Open the web browser with created gist
```