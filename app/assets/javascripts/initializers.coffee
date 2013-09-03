$ ->
  $('input, textarea').placeholder()
  $('[rel="select-on-click"]').on 'click', ->
    $(@).select()
