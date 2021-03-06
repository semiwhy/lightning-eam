Template.createMeterPage.onCreated ->
  self = this
  self.autorun -> self.subscribe 'singleLocation', (Session.get('currentID').toString())

Template.createMeterPage.onRendered ->
  $(".dropdown-button").dropdown()
  $('.tooltipped').tooltip {delay: 50}

Template.createMeterPage.onDestroyed ->
  $('.tooltipped').tooltip 'remove'

Template.createMeterPage.helpers
  customTemplate: -> Customisations.createMeter
  currentDoc: ->
    Collections.Locations.Current = Locations.findOne {'id':Session.get('currentID').toString()}
    return Collections.Locations.Current

Template.createMeterPage.events
  'click .createMeter .btnSubmit': ->
    doc = Collections.Locations.Current
    meter =
      text: $('#inpCreateMeterPageTitle').val()
      id: $('#inpCreateMeterPageID').val()
      units: $('#inpCreateMeterPageUnits').val()
      reading: $('#inpCreateMeterPageReading').val()
    Meteor.call 'createMeter', doc, meter, (error, result) ->
      if error
        toast 'error', error
      else
        toast 'success', result
      return
    FlowRouter.go history.back()
