Template.duplicateLocationPage.onCreated ->
  self = this
  self.autorun ->
    self.subscribe 'singleLocation', (Session.get('currentID').toString())

Template.duplicateLocationPage.helpers
  customTemplate: -> Customisations.duplicateLocation
  duplicateDoc: ->
    Collections.Locations.Current = Locations.findOne {'id':Session.get('currentID').toString()}
    return Collections.Locations.Current
  locationFormSchema: -> Schema.locations
