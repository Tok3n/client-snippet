# Tok3n JS Snippet

This repo contains tok3n.js, a script that handles loading and displaying the Tok3n authentication iframe. The tok3n.js file should be included in a script tag in any page that requires Tok3n authentication.

## Tok3n global variable
The script exposes a global variable Tok3n with three methods.
- `Tok3n.showIFrame` reveals the iframe and passes some basic information to it. Takes no arguments.
- `Tok3n.hideIFrame` hides the iframe.
- `Tok3n.tok3nElement` returns the element rendered according to data- attributes, if any.

## `<script>` Data Attributes
You can set data- attributes on the script tag in order to render a button, link, or other element at the location within HTML where the script appears. You must give the script tag `data-tok3n-integration` if you want it to render an element. The element will have a click event handler registered on it to open the iframe. There are four further data attributes you can set.

- ### data-tag-name
  The tag name of the element you wish to render. Defaults to "button"

- ### data-tag-inner-html
  The inner HTML of the element you wish to render. Defaults to "Authenticate with Tok3n"

- ### data-tag-class-name
  A space-separated list of CSS classes you wish to be added to the element. Defaults to "tok3n-authenticate"

- ### data-tag-id
  The id you wish to set on the element. Defaults to "tok3n-authenticate"

Usage would look something like:
```HTML
<script src="js/tok3n.js"
  data-tok3n-integration
  data-tag-name="a"
  data-tag-inner-html="Login With Tok3n"
  data-tag-class-name="link-lg link-important"
  data-tag-id="tok3n-link">
```

## Using the snippet

First, get the js-ui branch of the (validation page)[https://github.com/Tok3n/validation-page/tree/js-ui] repo. Run that project with `foreman start`. Then run this, nothing fancy, just python -m SimpleHTTPServer 8000. Open up localhost:8000/example/index.html and you should see the example page, with a button rendered by the script that will reveal the iframe. Enjoy!