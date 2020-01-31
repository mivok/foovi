# foovi

Simple implementation of the 'foovi' pattern, where you want to query an API,
edit the results in your text editor, and apply any changes back to the API.
This is useful for providing a text editor like interface to an API, or for
editing files (or file like things) that are remote.

The pattern is as follows:

* You supply a command that gets an object from an api, and another command
  that posts an object back to the api.
* The get command is run, with the output being sent to a temporary file.
* You edit the temporary file, and save it.
* The post command is run, sending the temporary file back to the api.

## Scripts

* httpbinvi.sh - example script demonstrating the behavior using httpbin
* route53vi.sh - edit route53 records in your text editor
* s3vi.sh - edit files in s3 directly in your text editor

## Making a new script

Foovi scripts are simply shell scripts that provide a get and post function.
The first argument to each function (`"$1"`) is the name of the temporary file
that contains the results of the api call (in the case of the get function),
or the edited contents to be sent back up (in the case of the post function).

Note: even though the functions are called 'get' and 'post', they don't have
to be http GETs and POSTs, in fact they don't have to be http calls at all.

If you want to pass arguments to your script (you probably do), then set them
at the top of the script from `"$1", "$2" and so on.` (you want to store them
in named variables such as `$FILE` because `"$1"` refers to the temporary
filename inside your get/post functions.

Once you have your functions created, add the following line to the top of
your script to load the foovi library:

```sh
. "${BASH_SOURCE%/*}/foovi.sh"
```

And that's it. Test out your script and make sure the editing functionality
works.
