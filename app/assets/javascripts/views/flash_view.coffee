class @FlashView extends Backbone.View
  el: 'body'

  initialize: =>
    @$messageContainer = @$el.find(".flash-messages")
    @$messages = @$el.find(".flash-message")
    if @$messages.length > 0
      @$messageContainer.slideDown(500)
      setTimeout( =>
        @$messageContainer.slideUp(250)
      , 5000)
