Template.reportsPage.onCreated ->
  # Set Navbar so Reports highlighted
  $('#header1DesktopUL li').removeClass 'active'
  $('#header1DesktopUL li').eq(6).addClass 'active'

Template.reportsPage.onRendered ->
  $(".dropdown-button").dropdown()  
  $('.tooltipped').tooltip {delay: 50}

Template.reportsPage.onDestroyed ->
  $('.tooltipped').tooltip 'remove'

Template.reportsPage.helpers
  customTemplate: -> Customisations.reports
