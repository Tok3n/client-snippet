IFRAME_URL = "http://localhost:5000/iframe"

CSS_STR = """
#tok3n-iframe {
  overflow: hidden;
  opacity: 0;
  position: fixed;
  top: 0;
  left: 0;
  height: 0;
  width: #{ document.documentElement.clientWidth }px;
  width: 100vw;
  border: none;
  z-index: 9999;
} 
#tok3n-iframe.visible {
  height: #{ document.documentElement.clientHeight }px;
  height: 100vh;
  opacity: 1;
}
"""

# extend = (out) ->
#   out = out or {}
#   i = 1
#   while i < arguments_.length
#     continue  unless arguments_[i]
#     for key of arguments_[i]
#       out[key] = arguments_[i][key]  if arguments_[i].hasOwnProperty(key)
#     i++
#   out

tagDefaults = 
  name : "button"
  innerHtml : "Authenticate with Tok3n"
  className : "tok3n-authenticate"
  id : "tok3n-authenticate"

head = document.head or document.getElementsByTagName( "head" )[0]
stylesheet = document.createElement "style"
stylesheet.type = "text/css"
stylesheet.appendChild document.createTextNode CSS_STR
head.appendChild stylesheet

iframe = document.createElement( "iframe" )
iframe.src = IFRAME_URL
iframe.id = "tok3n-iframe"
iframe.setAttribute "allowtransparency", true
document.body.appendChild iframe
iframeOrigin = ( new URL iframe.src ).origin

@Tok3n = Tok3n = do ->

  # ... this should probably be simpler. 
  postMessage = ( msg ) ->
    msg.parentOrigin = window.location.origin
    iframe.contentWindow.postMessage msg, iframeOrigin

  messageHandler = ( message ) ->
    switch message.type
      when "hideComplete"
        iframe.classList.remove "visible"
      when "showComplete"
        iframe.classList.add "visible"

  # check that message origin is the iframe before handling message
  iframe.addEventListener "load", ( event ) ->
    window.addEventListener "message", ( event ) ->
      if event.origin is iframeOrigin
        messageHandler( event.data )
    , false
  , false

  # public methods available under global Tok3n namespace go here.
  showIFrame : (trgt) ->
    postMessage
      cmd: "show"
      target: trgt
    iframe.classList.add "visible"
    iframe.focus()

  hideIFrame : ->
    postMessage cmd: "hide"


# locate this script, if we need to append a button or something where it appears
script = document.querySelector "script[data-tok3n-integration]"
if script
  el = document.createElement( script.dataset.tagName or tagDefaults.name )
  el.innerHTML = script.dataset.tagInnerHtml or tagDefaults.innerHtml
  el.id = script.dataset.tagId or tagDefaults.id
  el.className = script.dataset.tagClassName or tagDefaults.className
  if el.tagName.toLowerCase() is "a"
    el.href = "javascript:void(0)"
  # Please note the target of the iframe is hardcoded
  el.addEventListener "click", -> Tok3n.showIFrame("authorize")
  script.parentElement.insertBefore( el, script )
  tok3nElement = el