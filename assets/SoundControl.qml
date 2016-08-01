import bb.cascades 1.3

Page {
    titleBar: TitleBar {
        kind: TitleBarKind.FreeForm
        kindProperties: FreeFormTitleBarKindProperties {
            Container {
                layout: DockLayout { }
                leftPadding: 10
                rightPadding: 10
                
                Label {
                    text: qsTr("Sound control")
                    textStyle {
                        color: Application.themeSupport.theme.colorTheme.style == VisualStyle.Dark ? Color.White : Color.Black
                    }
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
                }
            }
        }
    }
    
    property variant pageEditRadio
    
    

    Container {
      layout: StackLayout {
          orientation: LayoutOrientation.TopToBottom
      }
      
      Container {
          preferredHeight: ui.du(1)
      }
      
      
      // --------------------------------------------------------------------------
      
      Container {
          layout: StackLayout { orientation: LayoutOrientation.LeftToRight }
          
          Label {
              text: qsTr("Radios")
              textStyle.fontSize: FontSize.Large
              horizontalAlignment: HorizontalAlignment.Left
              verticalAlignment: VerticalAlignment.Bottom
          }
      
      }
      Divider { visible: dataModel.empty }
      
      Container {
          horizontalAlignment: HorizontalAlignment.Fill
          layout: DockLayout { }
          
          Container {  
              id: dataEmptyLabel
              visible: dataModel.empty //model.isEmpty() will not work  
              horizontalAlignment: HorizontalAlignment.Center  
              verticalAlignment: VerticalAlignment.Center
              
              layout: DockLayout {}
              
              Label {
                  text: qsTr("No online sources.")
                  verticalAlignment: VerticalAlignment.Center
                  horizontalAlignment: HorizontalAlignment.Center
              }
          }
          
          ListView {
              id: radioList
              listItemComponents: [
                  ListItemComponent {
                      type: "item"
                      
                      Container {
                          preferredHeight: ui.du(12)
                          id: listItemContainer
                          horizontalAlignment: HorizontalAlignment.Fill
                          verticalAlignment: VerticalAlignment.Center
                          layout: DockLayout {
                          }
                          
                          Container {
                              verticalAlignment: VerticalAlignment.Center
                              layout: StackLayout {
                                  orientation: LayoutOrientation.LeftToRight
                              }
                              Container {
                                  preferredWidth: ui.du(0.1)
                              }
                              
                              Label {
                                  text: ListItemData.name 
                                  verticalAlignment: VerticalAlignment.Center
                              }
                          }
                          
                          Divider {}
                          
                          contextActions: [
                              ActionSet {
                                  title: qsTr("Radio")
                                  
                                  ActionItem {
                                      title: qsTr("Edit")
                                      imageSource: "asset:///images/icon_write_context.png"
                                      onTriggered: {
                                          listItemContainer.ListItem.view.editEntry(ListItemData.id, ListItemData.name, ListItemData.url);
                                      }
                                  }
                                  
                                  DeleteActionItem {
                                      title: qsTr("Delete entry")
                                      onTriggered: {
                                          listItemContainer.ListItem.view.deleteEntry(ListItemData.id);
                                      }
                                  }
                              }
                          ]
                      }
                  }
              ]
              
              onTriggered: {
                  var chosenItem = dataModel.data(indexPath);
                  
                  karotz.playUrl(chosenItem.url);
              }
              
              function deleteEntry(id) {
                  karotz.deleteRadio(id);
              }
              
              function editEntry(id, name, url_str) {
                  if(!pageEditRadio)
                      pageEditRadio = newRadio.createObject();
                  
                  pageEditRadio.id_radio = id;
                  pageEditRadio.name     = name;
                  pageEditRadio.url_name = url_str;
                  
                  nav.push(pageEditRadio);
              }
              
              dataModel: GroupDataModel {
                  id: dataModel    
                  grouping: ItemGrouping.None
                  sortingKeys: ["id"]     
                  
                  property bool empty: true
                  
                  
                  onItemAdded: {
                      empty = isEmpty();
                  }
                  onItemRemoved: {
                      empty = isEmpty();
                  }  
                  onItemUpdated: empty = isEmpty()  
                  
                  // You might see an 'unknown signal' error  
                  // in the QML-editor, guess it's a SDK bug.  
                  onItemsChanged: empty = isEmpty()      
              }
          
          }
      }
      
    }  
    
    attachedObjects: [
        ComponentDefinition {
            id: newRadio
            source: "NewRadio.qml"
        }
    ]
    
    actions: [
        ActionItem {
            id: add
            imageSource: "asset:///images/icon_add.png"
            ActionBar.placement: ActionBarPlacement.Signature
            title: qsTr("Add")
            onTriggered: {
                if(!pageEditRadio)
                    pageEditRadio = newRadio.createObject();
                pageEditRadio.id_radio = -1;
                nav.push(pageEditRadio);
            }
        }
    ]
    
    onCreationCompleted: {
        karotz.setRadioListView(radioList);
        karotz.getRadioList();
    }
    
}
