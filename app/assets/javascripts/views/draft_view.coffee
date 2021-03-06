class @DraftView extends Backbone.View
  el: '.drafts-show'

  events:
    'click .available-button': 'showAvailableView'
    'click .drafted-button': 'showDraftedView'

  initialize: =>
    @$draftedButton = @$el.find(".drafted-button")
    @$availableButton = @$el.find(".available-button")
    @$draftedView = @$el.find(".drafted-view")
    @$availableView = @$el.find(".available-view")

    @showDraftedView()

  showAvailableView: =>
    @$draftedButton.removeClass("active")
    @$draftedView.addClass("hidden")

    @$availableButton.addClass("active")
    @$availableView.removeClass("hidden")

  showDraftedView: =>
    @$availableButton.removeClass("active")
    @$availableView.addClass("hidden")

    @$draftedButton.addClass("active")
    @$draftedView.removeClass("hidden")
