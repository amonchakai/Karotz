import bb.cascades 1.3
import Utility.TaskManager 1.0

Page {
    titleBar: TitleBar {
        kind: TitleBarKind.FreeForm
        kindProperties: FreeFormTitleBarKindProperties {
            Container {
                layout: DockLayout { }
                leftPadding: 10
                rightPadding: 10
                
                Label {
                    text: qsTr("Task Manager")
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
        
        // --------------------------------------------------------------------------
        
        
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
                    text: qsTr("Nothing programmed.")
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
                }
            }
            
            ListView {
                id: taskList
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
                                    title: qsTr("Task")
                                    
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
                    

                }
                
                function deleteEntry(id) {
                    taskManager.deleteTask(id);
                }
                
                function editEntry(id, name, url_str) {
                    
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
        TaskManager {
            id: taskManager
        }
    ]
    
    
    
    onCreationCompleted: {
        taskManager.setTaskList(taskList);
        taskManager.loadList();
    }

}
