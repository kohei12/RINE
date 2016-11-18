jQuery(document).on 'turbolinks:load', ->
  messages = $('#messages')
  if $('#messages').length > 0

    App.room = App.cable.subscriptions.create { channel: "RoomChannel", room_id: messages.data('room_id') },
      connected: ->

      disconnected: ->

      received: (data) ->
        $('#messages').append data['message']

      speak: (message) ->
        @perform 'speak', message: message

    $(document).on 'keypress', '[data-behavior~=room_speaker]', (event) ->
      if event.keyCode is 13 # return = send
        App.room.speak event.target.value
        event.target.value = ''
        event.preventDefault()
