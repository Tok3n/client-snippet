
IFRAME_URL = "http://localhost:5000/login-v2"

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
tagDefaults = 
  name : "button"
  innerHtml : "Authenticate with Tok3n"
  className : "tok3n-authenticate-button"
  id : "tok3n-authenticate-button"

head = document.head or document.getElementsByTagName( "head" )[0]
stylesheet = document.createElement( "style" )
stylesheet.type = "text/css"
stylesheet.appendChild document.createTextNode CSS_STR
head.appendChild stylesheet

iframe = document.createElement( "iframe" )
iframe.src = IFRAME_URL
iframe.id = "tok3n-iframe"
iframe.setAttribute "allowtransparency", true
document.body.appendChild iframe

getOrigin = ( iframe ) ->
  return ( new URL iframe.src ).origin

@Tok3n = Tok3n = do ( iframe = iframe ) ->

  origin = getOrigin( iframe )

  postMessage = ( msg ) ->
    msg.parentOrigin = window.location.origin
    iframe.contentWindow.postMessage msg, origin

  messageHandler = ( message ) ->
    switch message.type
      when "hideComplete"
        iframe.classList.remove "visible"

  window.addEventListener "message", ( event ) ->
    if event.origin is origin
     messageHandler( event.data )

  # public methods available under global Tok3n namespace go here.
  pub =
    showIFrame : ->
      postMessage cmd: "show"
      iframe.classList.add "visible"

    hideIFrame : ->
      postMessage cmd: "hide"
  
  return pub

# locate this script, if we need to append a button or something where it appears
script = document.querySelector "script[data-tok3n-integration]"
if script.hasAttribute( "data-render-tag" )
  el = document.createElement( script.dataset.tagName or tagDefaults.name )
  el.innerHTML = script.dataset.tagInnerHtml or tagDefaults.innerHtml
  el.id = script.dataset.tagId or tagDefaults.id
  el.className = script.dataset.tagClassName or tagDefaults.className
  if el.tagName.toLowerCase() is "a"
    el.href = "javascript:void(0)"
  el.addEventListener "click", Tok3n.showIFrame
  script.parentElement.insertBefore( el, script )