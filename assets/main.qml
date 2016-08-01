import bb.cascades 1.3
import Utility.KarotzController 1.0


TabbedPane {
    id: mainTab
    showTabsOnActionBar: false
    activeTab: tabHome
    
    Menu.definition: MenuDefinition {
        actions: [
            ActionItem {
                title: qsTr("Policy")
                imageSource: "asset:///images/icon_about.png"
                onTriggered: {
                    about.open();
                }
            },
            ActionItem {
                title: qsTr("Settings")
                imageSource: "asset:///images/icon_settings.png"
                onTriggered: {
                    settings.open();
                }
            },
            ActionItem {
                title: qsTr("Donate")
                imageSource: "asset:///images/icon_credit.png"
                onTriggered: {
                    payment.open();
                }
            }
        ]
    }  
    
    
    Tab { //First tab
        // Localized text with the dynamic translation and locale updates support
        id: tabHome
        title: qsTr("Actions") + Retranslate.onLocaleOrLanguageChanged
        ActionBar.placement: ActionBarPlacement.OnBar
        imageSource: "asset:///images/icon_play.png"
        
        delegateActivationPolicy: TabDelegateActivationPolicy.Default
        
        delegate: Delegate {
            source: "Status.qml"
        }
    
    } 
    
    Tab { //First tab
        // Localized text with the dynamic translation and locale updates support
        id: tabTask
        title: qsTr("Programs") + Retranslate.onLocaleOrLanguageChanged
        ActionBar.placement: ActionBarPlacement.OnBar
        imageSource: "asset:///images/icon_clock.png"
        
        delegateActivationPolicy: TabDelegateActivationPolicy.Default
        
        delegate: Delegate {
            source: "TaskManager.qml"
        }
    
    } 
    
    onCreationCompleted: {
        if(!karotzController.isLogged()) {
            welcome.open();
        }
    }
        
    attachedObjects: [
        KarotzController {
            id: karotzController
            
            onLoggedIn: {
                welcome.close();
            }
        },
        
        
        
        
        
        Delegate {
            id: welcomeDelegate
            source: "Welcome.qml"
            
        },
        Sheet {
            id: welcome
            content: welcomeDelegate.object
            onOpenedChanged: {
                if (opened)
                    welcomeDelegate.active = true;
            }
            onClosed: {
                welcomeDelegate.active = false;
            }
        },
        Delegate {
            id: settingsDelegate
            source: "Settings.qml"
        },
        Sheet {
            id: settings
            content: settingsDelegate.object
            onOpenedChanged: {
                if(opened)
                    settingsDelegate.active = true;
            }
            onClosed: {
                settingsDelegate.active = false;
            }
        },
        Delegate {
            id: aboutDelegate
            source: "Policy.qml"
        }, 
        Sheet {
            id: about
            content: aboutDelegate.object
            onOpenedChanged: {
                aboutDelegate.active = true;
            }
            onClosed: {
                aboutDelegate.active = false;
            }
        },
       Delegate {
           id: paymentDelegate
           source: "Payment.qml"
       
       },
       Sheet {
           id: payment
           content: paymentDelegate.object
           onOpenedChanged: {
               if (opened)
                   paymentDelegate.active = true;
           }
           onClosed: {
               paymentDelegate.active = false;
           }
       }
    ]
    
}




