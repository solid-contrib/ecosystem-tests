# Bookmarks interop with fine-grained access

This manual test checks the following capabilities of the Solid eco-system

* A user can launch the Solid app "Markbook" and store a bookmark (description + URL) in their pod
* They can then launch the Solid app "Poddit", see the bookmark they created in Markbook, and edit it
* They can then go back to Markbook and see the edit show up
* Neither Poddit nor Markbook requires root access to the pod, access to 'bookmarks' is enough

This test, in its current form, uses the following live servers:
* [Launcher](https://github.com/pdsinterop/launcher-exploration) on https:/solid.pondersource.com/ (authorization agent)
* [NSS](https://github.com/nodeSolidServer/node-solid-server) on https://solidcommunity.net (IDP and storage)
* [Markbook](https://github.com/michielbdejong/markbook) on https://michielbdejong.github.io/markbook/ (one of the applications)
* [Poddit](https://gitlab.com/vincenttunru/poddit/-/tree/master) on https://poddit.app/ (the other application)


## Manual test execution
1) Visit [the launcher](https://solid.pondersource.com) and click 'Connect and launch' for Markbook
2) Type in your pod server URL (FIXME: https://github.com/pdsinterop/launcher-exploration/issues/1)
3) Log in to your pod, give the launcher full access including control access
4) Use Markbook to store a bookmark
5) Go back to the launcher and click 'Allow and launch' for Poddit
6) See the bookmark and edit it
7) Go back to Markbook and (FIXME: https://github.com/michielbdejong/markbook/issues/1) refresh the page
8) See the edit from Poddit show up in Markbook