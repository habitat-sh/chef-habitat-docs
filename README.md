# Habitat Documentation

The Habitat Documentation is deployed on <https://docs.chef.io/habitat/>.

## The Fastest Way to Contribute

### Update Habitat Documentation

The fastest way to change the documentation is to edit a page on the
GitHub website using the GitHub UI.

We also require contributors to include their [DCO signoff](https://github.com/chef/chef/blob/master/CONTRIBUTING.md#developer-certification-of-origin-dco)
in the comment section of every pull request, except for obvious fixes. You can
add your DCO signoff to the comments by including `Signed-off-by:`, followed by
your name and email address, like this:

`Signed-off-by: Julia Child <juliachild@chef.io>`

See our [blog post](https://blog.chef.io/introducing-developer-certificate-of-origin/)
for more information about the DCO and why we require it.

After you've added your DCO signoff, add a comment about your proposed change,
then click on the "Propose file change" button at the bottom of the page and
confirm your pull request. The CI system will do some checks and add a comment
to your PR with the results.

The Chef documentation team can normally merge pull requests within seven days.
We'll fix build errors before we merge, so you don't have to
worry about passing all the CI checks, but it might add an extra
few days. The important part is submitting your change.

## Local development environment

We use [Hugo](https://gohugo.io/), [Go](https://golang.org/), [NPM](https://www.npmjs.com/),
[go-swagger](https://goswagger.io/install.html), and [jq](https://stedolan.github.io/jq/).
You will need Hugo 0.146 or higher installed and running to build and view our documentation properly.

To install Hugo, NPM, and Go on Windows and macOS:

- On macOS run: `brew tap go-swagger/go-swagger && brew install go-swagger hugo node go jq`
- On Windows run: `choco install hugo nodejs golang jq`
  - See the Go-Swagger [docs to install go-swagger](https://goswagger.io/install.html)

To install Hugo on Linux, run:

- `apt install -y build-essential`
- `sudo apt-get install jq`
- `snap install node --classic --channel=12`
- `snap install hugo --channel=extended`
- See the Go-Swagger [docs](https://goswagger.io/install.html) to install go-swagger

1. (Optional) [Install cspell](https://github.com/streetsidesoftware/cspell/tree/master/packages/cspell)

    To be able to run the optional `make spellcheck` task you'll need to install `cspell`:

    ```shell
    npm install -g cspell
    ```

## Preview Habitat documentation

Use one of the following methods to preview the documentation in `habitat-sh/chef-habitat-docs`:

- submit a pull request
- run `make serve`

### Submit a PR

When you submit a PR to `habitat-sh/chef-habitat-docs`, Netlify builds the documentation
and add a notification to the GitHub pull request page. You can review your
documentation changes as they would appear on docs.chef.io.

### make serve

- Run `make serve`
- go to <http://localhost:1313>

#### Clean your local environment

To clean your local environment, run `make clean_all`.

## Release notes

Release notes allow product engineering to communicate the list of features that are shipping in the builds being promoted to `stable`. Remember release notes aren't changelogs! The audience is our end-users, not other engineers. If you need a quick primer on what goes into good release notes, take a look at these excellent articles:

- [The Life-Changing Magic of Writing Release Notes](https://medium.com/@DigitalGov/the-life-changing-magic-of-writing-release-notes-4c460970565)
- [Let's All Appreciate These Great Release Notes Together](https://www.prodpad.com/blog/writing-release-notes/)

Capture the release notes on the [Pending Release Notes wiki page](https://github.com/habitat-sh/chef-habitat-docs/wiki/Pending-Release-Notes). All edits should be completed and reviewed by a member of the Documentation Team before Habitat is promoted to `stable`. It's the responsibility of the _individual development teams_ to ensure the release notes are updated with any features and breaking changes that ship when Habitat is promoted to the `stable` channel. We encourage teams to make updating these release notes part of their weekly rituals. Whatever is in the wiki page at promotion time is what goes out with the release!

During the promotion to the `stable` channel, the release notes will be extracted from the wiki page and published to an S3 bucket. The published release notes are then available at the following URLs:

```text
https://docs.chef.io/release_notes_habitat/
https://packages.chef.io/release-notes/habitat/<VERSION>.md
```

## Documentation feedback

We love getting feedback, questions, or comments.

Send an email to <Chef-Docs@progress.com> for documentation bugs,
ideas, thoughts, and suggestions. This email address isn't a
support email address. If you need support, contact [Chef Support](https://www.chef.io/support/).

Submit an issue to the [Habitat repo](https://github.com/habitat-sh/chef-habitat-docs/issues)
for "important" documentation bugs that may need visibility among a larger group,
especially in situations where a doc bug may also surface a product bug.
