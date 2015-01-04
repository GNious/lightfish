#ifndef LIFXLIGHTSMODEL_H
#define LIFXLIGHTSMODEL_H

#include <QAbstractListModel>
#include <QList>
#include <QMap>

#include "lifxlightclient.h"

class LIFXLightsModel : public QAbstractListModel
{
    Q_OBJECT

	QList<QTIoT::LIFX::LIFXLightClient*> m_lightsList;
	//QList<QPointer> m_lightsList;
	QMap<int, bool> m_lightsSelected;

public:
    enum LIFXLightsRoles {
        LabelRole = Qt::UserRole + 1,
        ColorRole,
        TemperatureRole,
        BrightnessRole,
		SaturationRole,
        PowerRole,
		TimeRole,
		//This is purely UI/UX-related
		SelectedRole
    };

    explicit LIFXLightsModel(QObject *parent = 0);

	Q_INVOKABLE int rowCount(const QModelIndex & parent = QModelIndex()) const { if(parent.isValid()) {return 0;} return m_lightsList.count();};

    //bool insertRow(int row, const QModelIndex & parent = QModelIndex());
    //bool setData(const QModelIndex & index, const QVariant & value, int role = Qt::EditRole);
    Q_INVOKABLE bool appendLight(  QTIoT::LIFX::LIFXLightClient* light, int index = -1);
    Q_INVOKABLE QTIoT::LIFX::LIFXLightClient* getLight( int index );
	Q_INVOKABLE int countSelectedLights();
	Q_INVOKABLE bool isSelectedLight(int index);
	QVariant data(const QModelIndex& index, int role) const;
	bool setData(const QModelIndex & index, const QVariant & value, int role = Qt::EditRole);
	Qt::ItemFlags flags(const QModelIndex & /*index*/) const;

protected:
    QHash<int, QByteArray> roleNames() const;

signals:

public slots:

};

#endif // LIFXLIGHTSMODEL_H
