url = location.href
host = url.match(/^.*?\/\/([^\/]+)/)[1]

$ ->
  socket = io.connect "http://#{host}"
  socket.on 'msg', (msg) ->
    $('.no-message').hide()
    $('#messages').append $('<p/>', text: msg)

  $('#form').submit (evt) ->
    evt.preventDefault()
    # alert 'submit'
    msg = $('#input').val()
    socket.emit 'msg', msg
    $('#input').val('')
