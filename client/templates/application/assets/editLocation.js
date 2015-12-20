Template.editLocationPage.onCreated(function() {
  var self = this;
   self.autorun(function() {
     self.subscribe('singleLocation', Session.get("idTreeView").toString());
   });
});

Template.editLocationPage.helpers({
  currentDoc: function() {
    return Locations.findOne({"id":Session.get("idTreeView").toString()});
  },
  asset: function() {
    alert(Locations.findOne({"id":Session.get("idTreeView")}).type)
    return Locations.findOne({"id":Session.get("idTreeView")}).type == "asset";
  },
  locationFormSchema: function() {
    return Schema.locations;
  }
});
