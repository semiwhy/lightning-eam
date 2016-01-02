Template.viewAssetPage.onCreated ->
  self = this
  self.autorun ->
    self.subscribe 'singleLocation', (Session.get('currentID').toString())
  Collections.Locations.Current = Locations.findOne {'id':Session.get('currentID').toString()}

Template.viewAssetPage.helpers
  viewDoc: -> Collections.Locations.Current;
  meterValue: -> this.reading

Template.viewAssetPage.events
  'click #btnViewAssetPageEdit': ->
    if (Session.get('currentID').toString() == '#')
      alert 'No location or asset selected!'
    else
      if (Collections.Locations.Current.type == 'asset')
        FlowRouter.go '/assets/edit-asset'
      else
        FlowRouter.go '/assets/edit-location'
  'click #btnViewAssetPageCopy': ->
    if (Session.get('currentID').toString() == '#')
      alert 'No location or asset selected!'
    else
      if (Collections.Locations.Current.type == 'asset')
        FlowRouter.go '/assets/duplicate-asset'
      else
        FlowRouter.go '/assets/duplicate-location'
