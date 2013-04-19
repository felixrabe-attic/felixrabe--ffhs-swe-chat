$ ->
  socket = io.connect 'http://localhost'
  socket.on 'msg', (msg) ->
    $('.no-message').hide()
    $('#messages').append $('<p/>', text: msg)

  $('#form').submit (evt) ->
    evt.preventDefault()
    # alert 'submit'
    msg = $('#input').val()
    socket.emit 'msg', msg
    $('#input').val('')
