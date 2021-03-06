Template.viewPeoplePage.onCreated ->
  # Set Navbar so Resources highlighted
  $('#header1DesktopUL li').removeClass 'active'
  $('#header1DesktopUL li').eq(3).addClass 'active'
  self = this
  self.autorun ->
    self.subscribe 'directory'

Template.viewPeoplePage.onRendered ->
  $(".dropdown-button").dropdown()
  $('.tooltipped').tooltip {delay: 50}

Template.viewPeoplePage.onDestroyed ->
  $('.tooltipped').tooltip 'remove'

Template.viewPeoplePage.helpers
  customTemplate: -> Customisations.viewPeople
  userEmail: -> this.emails[0].address
  userID: -> this._id
  userRole: -> this.roles[0]
  settings: ->
    return {
      rowsPerPage: 10
      showFilter: true
      fields:  [
        { key: 'profile.firstName', label: ' First Name' }
        { key: 'profile.lastName', label: 'Last Name' }
        { key: 'profile.cpyName', label: 'Company' }
        { key: 'profile.cpyDiv', label: 'Division' }
        { key: 'emails.0.address', label: 'Email' }
        { key: 'roles.0', label: 'Role' }
        { key: 'location', label: 'Edit/Secure/Delete', tmpl: Template.editPerson }
      ]
    }

Template.viewPeoplePage.events
  'click .viewPeople .btnEach': (event) ->
    Collections.Users.Current = this
    FlowRouter.go '/resources/edit-people'
  'click .viewPeople .btnEach2': (event)  ->
    Collections.Users.Current = this
    FlowRouter.go '/resources/credentials'
  'click .viewPeople .btnDelete': (event) ->
    Collections.Users.Current = this
    $('#viewPeoplePageModal').openModal()
  'click .viewPeople .btnConfirm': (event) ->
    temp = Collections.Users.Current
    Meteor.call 'deleteUser', temp._id, (error, result) ->
      if error
        toast 'error', error
      else
        toast 'success', result
      return
    FlowRouter.go '/resources'

Template.editPerson.onRendered ->
  $('.tooltipped').tooltip {delay: 50}

Template.editPerson.onDestroyed ->
  $('.tooltipped').tooltip 'remove'
