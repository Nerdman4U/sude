# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("a[data-remote]").on "ajax:success", (e, data, status, xhr) ->
    if $(e.target).hasClass("voted")
      $(e.target).removeClass("voted")
    else
      $(e.target).addClass("voted")

    $(e.target).data({'method': 'put'})
    $(e.target).url = e.originalEvent.detail[0]["url"]

    # Data is found from e.originalEvent.detail... "data" in parameter is empty?
    a_count = e.originalEvent.detail[0]["anonymous_vote_count"] || 0
    c_count = e.originalEvent.detail[0]["confirmed_vote_count"] || 0
    $(e.target).parent().siblings(".anonymous_count").html(a_count)
    $(e.target).parent().siblings(".confirmed_count").html(c_count)
    