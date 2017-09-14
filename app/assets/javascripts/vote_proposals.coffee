# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("a[data-remote]").on "ajax:success", (e, data, status, xhr) ->
    if e.originalEvent.detail[0]["invalid"]
      return
    
    if $(e.target).hasClass("voted")
      $(e.target).removeClass("voted")
    else
      $(e.target).addClass("voted")

    $(e.target).data({'method': 'put'})

    # Data is found from e.originalEvent.detail... "data" in parameter is empty?
    a_count = e.originalEvent.detail[0]["anonymous_vote_count"] || 0
    c_count = e.originalEvent.detail[0]["confirmed_vote_count"] || 0

    if $(e.target).parent().siblings(".anonymous_count").length > 0
      a_node = $(e.target).parent().siblings(".anonymous_count")
      c_node = $(e.target).parent().siblings(".confirmed_count")
    else
      a_node = $(e.target).parent().find(".anonymous_count")      
      c_node = $(e.target).parent().find(".confirmed_count")      
          
    a_node.html(a_count)
    c_node.html(c_count)