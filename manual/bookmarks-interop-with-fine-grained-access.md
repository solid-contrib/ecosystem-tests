# Bookmarks interop with fine-grained access

This manual test checks the following capabilities of the Solid eco-system

* A user can launch the Solid app "Markbook" and store a bookmark (description + URL) in their pod
* They can then launch the Solid app "Poddit", see the bookmark they created in Markbook, and edit it
* They can then go back to Markbook (FIXME: a page refresh is necessary) and see the edit show up

This test, in its current form, uses the following live servers:
* https://solidcommunity.net (IDP and storage server)
* https://michielbdejong.github.io/markbook/
* https://poddit.app/

And the following code repositories
* https://github.com/pdsinterop/launcher-exploration

## Manual test execution
1) Follow the instructions on https://github.com/pdsinterop/launcher-exploration
2) open the launcher with your browser on http://localhost:3000
3) [log in ...]