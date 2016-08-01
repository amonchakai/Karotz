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
                    text: qsTr("RFID control")
                    textStyle {
                        color: Application.themeSupport.theme.colorTheme.style == VisualStyle.Dark ? Color.White : Color.Black
                    }
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
                }
            }
        }
    }
    
    property variant pageEditRFID
    property bool recordState
    
    
    ScrollView {
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }
            
            Container {
                preferredHeight: ui.du(1)
            }
            
            Label {
                text: qsTr("Management")
            }
            
            Divider { }
            
            
            Container {
                horizontalAlignment: HorizontalAlignment.Fill
                
                layout: DockLayout {}
                
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    horizontalAlignment: HorizontalAlignment.Left
                    verticalAlignment: VerticalAlignment.Center
                    
                    Container {
                        preferredWidth: ui.du(1)
                    }
                    
                    Label {
                        text: qsTr("Record new tags")
                        verticalAlignment: VerticalAlignment.Center
                        
                        leftMargin: ui.du(1)
                    }
                }
                
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    horizontalAlignment: HorizontalAlignment.Right
                    verticalAlignment: VerticalAlignment.Center
                    
                    ToggleButton {
                        checked: false
                        verticalAlignment: VerticalAlignment.Center
                        rightMargin: ui.du(1)
                        
                        onCheckedChanged: {
                            karotz.recordNewRFID(checked);
                        }
                    }
                    
                    Container {
                        preferredWidth: ui.du(1)
                    }
                }
            
            }
            
            Container {
                preferredHeight: ui.du(6)
            }
            
            // --------------------------------------------------------------------------
            
            Container {
                layout: StackLayout { orientation: LayoutOrientation.LeftToRight }
                
                Label {
                    text: qsTr("RFID")
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
                        text: qsTr("No RFID object recorded.")
                        verticalAlignment: VerticalAlignment.Center
                        horizontalAlignment: HorizontalAlignment.Center
                    }
                }
                
                ListView {
                    preferredHeight: ui.du(30)
                    id: rfidList
                    
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
                                        text: ListItemData.name == "" ? ListItemData.type_name + " - " + ListItemData.color_name : ListItemData.name
                                        verticalAlignment: VerticalAlignment.Center
                                    }
                                }
                                
                                Divider {}
                                
                                contextActions: [
                                    ActionSet {
                                        title: qsTr("RFID")
                                        
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
                    
                    function deleteEntry(id) {
                        karotz.deleteRFID(id);
                    }
                    
                    onTriggered: {
                        var chosenItem = dataModel.data(indexPath);
                        
                        if(!pageEditRFID)
                            pageEditRFID = editRFID.createObject();
                            
                        pageEditRFID.id = chosenItem.id;
                        pageEditRFID.name = chosenItem.name;
                        pageEditRFID.color = chosenItem.color_name;
                            
                        nav.push(pageEditRFID);
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
    }
    
    attachedObjects: [
        ComponentDefinition {
            id: editRFID
            source: "EditRFID.qml"
        }
    ]
    
    actions: [
        ActionItem {
            id: refresh
            imageSource: "asset:///images/icon_refresh.png"
            ActionBar.placement: ActionBarPlacement.Signature
            title: qsTr("Refresh")
            onTriggered: {
                karotz.getRFIDList();
            }
        }
    ]
    
    onCreationCompleted: {
        recordState = false;
        karotz.setRFIDListView(rfidList);
        karotz.getRFIDList();
    }
}
