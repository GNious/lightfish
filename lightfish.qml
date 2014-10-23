import QtQuick 2.0
import io.thp.pyotherside 1.0

Rectangle {
    color: 'black'
    width: 400
    height: 400

    ListView {
        anchors.fill: parent

        model: ListModel {
            id: listModel
        }

        delegate: Text {
            text: name
            color: 'white'
            //color: team
        }
    }

    Python {
        id: py

        Component.onCompleted: {
            // Add the directory of this .qml file to the search path
            addImportPath(Qt.resolvedUrl('.'));

            // Import the main module and load the data
            importModule('lightfish', function () {
            	console.log('lightfish imported');
                py.call('lightfish.get_data', [], function(result) {
                    // Load the received data into the list model
                    for (var i=0; i<result.length; i++) {
                        listModel.append(result[i]);
                    }
                });
                console.log('lightfish processed');
            });
        }
    }
}
