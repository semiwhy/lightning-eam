Template.inventoryPage.onCreated ->
  # Set Navbar so Inventory highlighted
  $('#header1DesktopUL li').removeClass 'active'
  $('#header1DesktopUL li').eq(4).addClass 'active'

Template.inventoryPage.onRendered ->
  $(".dropdown-button").dropdown()
  $('.tooltipped').tooltip {delay: 50}

Template.inventoryPage.onDestroyed ->
  $('.tooltipped').tooltip 'remove'

Template.inventoryPage.helpers
  customTemplate: -> Customisations.inventory

Template.inventoryPage.events
  'click .btnViewItemsClassifications': (event) ->
    Session.set 'treeviewData', 'item-classification'
    FlowRouter.go '/'+Collections.Classification.Folder+'/inventory/item/view-classifications'
  'click .btnViewEquipmentClassifications': (event) ->
    Session.set 'treeviewData', 'item-classification'
    FlowRouter.go '/'+Collections.Classification.Folder+'/inventory/equipment/view-classifications'
  'click .btnViewLocationClassifications': (event) ->
    Session.set 'treeviewData', 'item-classification'
    FlowRouter.go '/'+Collections.Classification.Folder+'/inventory/locations/view-classifications'
