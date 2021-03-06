Template.stockLevelsPage.onCreated ->
  self = this
  self.autorun ->
    self.subscribe 'singleBin', Collections.Bins.Current._id
    self.subscribe 'bins-list'
    self.subscribe 'wo-list'

Template.stockLevelsPage.onRendered ->
  $(".dropdown-button").dropdown()
  $('.tooltipped').tooltip {delay: 50}
  Session.set 'currentDoc', {} # Bin location
  Session.set 'currentDoc2', {} # Stock levels
  Session.set 'currentDoc3', {} # Work order

Template.stockLevelsPage.onDestroyed ->
  $('.tooltipped').tooltip 'remove'

Template.stockLevelsPage.helpers
  customTemplate: -> Customisations.stockLevels
  inventoryItems: ->
    temp = Session.get 'currentDoc'
    if jQuery.isEmptyObject(temp)
      Session.set 'currentDoc', Bins.findOne {_id: Collections.Bins.Current._id }
    temp.stock
  settings: -> ## Location Stock
    return {
      rowsPerPage: 10
      showFilter: true
      fields:  [
        { key: 'item_id', hidden: true  }
        { key: 'itemText', label: ' Title' }
        { key: 'stockLevel', label: ' Stock Level' }
        { key: 'reorderLevel', label: ' Reorder Level' }
        { key: 'orderQuantity', label: ' Order Quantity' }
        { key: '', label: 'Update/Transfer/Issue', tmpl: Template.rtEditMoveIssue }
      ]
    }

Template.stockLevelsPage.events
  'click .btnEdit': (event) ->
    Session.set 'currentDoc2', this
    temp = this.item_id
    MaterializeModal.confirm
      bodyTemplate: 'stockLevelsModal'
      title: 'Adjust Levels'
      callback: (error, response) ->
        if (response.submit)
          stockLevelsQty = Number($('#stockLevelsQty').val())
          reorderLevelsQty = $('#reorderLevelsQty').val()
          newOrderQty = $('#newOrderQty').val()
          Meteor.call 'updateInvLocation', Collections.Bins.Current._id, temp, stockLevelsQty, reorderLevelsQty, newOrderQty, (error, result) ->
            if error
              toast 'error', error
            else
              Session.set 'currentDoc', Bins.findOne {_id: Collections.Bins.Current._id }
              toast 'success', 'Goods received'
            return

  'click .btnMove': (event) ->
    Session.set 'currentDoc2', this
    temp = this.item_id
    MaterializeModal.confirm
      bodyTemplate: 'stockMoveModal'
      title: 'Move Stock'
      callback: (error, response) ->
        if (response.submit)
          moveStockQty = Number($('#moveStockQty').val())
          newBinLoc = Session.get('currentID').toString()
          Meteor.call 'moveStock', temp, Collections.Bins.Current._id, newBinLoc, moveStockQty, (error, result) ->
            if error
              toast 'error', error
            else
              Session.set 'currentDoc', Bins.findOne { _id: Collections.Bins.Current._id }
              toast 'success', 'Stock Moved'
            return

  'click .btnIssue': (event) ->
    Session.set 'currentDoc2', this
    temp = this.item_id
    MaterializeModal.confirm
      bodyTemplate: 'woIssueModal'
      title: 'Issue to Work Order'
      callback: (error, response) ->
        if (response.submit)
          issueStockQty = Number($('#issueStockQty').val())
          woID = Session.get('currentDoc3')._id
          Meteor.call 'issueStock', temp, Collections.Bins.Current._id, woID, issueStockQty, (error, result) ->
            if error
              toast 'error', error
            else
              Session.set 'currentDoc', Bins.findOne { _id: Collections.Bins.Current._id }
              toast 'success', 'Stock Issued'
            return

#------------------- Modals -------------------------------------

Template.stockLevelsModal.helpers
  stockDetails: -> Session.get 'currentDoc2'

Template.stockMoveModal.onRendered ->
  temp = Bins.find().fetch()
  dataTree(temp , 'general')

Template.stockMoveModal.helpers
  stockDetails: -> Session.get 'currentDoc2'
  invLocDetails: -> Bins.findOne {'id': Session.get('currentID').toString()}

Template.woIssueModal.helpers
  stockDetails: -> Session.get 'currentDoc2'
  woDetails: -> Session.get 'currentDoc3'
  settings: -> ## Work Order
    return {
      rowsPerPage: 10
      showFilter: true
      fields:  [
        { key: '_id', label: ' Sys ID'  }
        { key: 'text', label: ' Title' }
        { key: 'assetID', label: ' Asset ID' }
        { key: 'assetText', label: ' Asset' }
        { key: 'priority', label: ' Priority' }
        { key: '', label: 'Issue', tmpl: Template.rtAdd }
      ]
    }

Template.woIssueModal.events
  'click .btnAdd': (event) ->
    Session.set 'currentDoc3', this
